#!/bin/bash

# Validate input arguments
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <filter> <namespace> [context]"
  exit 1
fi

FILTER="$1"
NAMESPACE="$2"
KCONTEXT="$3"

DT_FORMAT="YYYY-MM-DD HH:MM:SS (UTC)"
DT_EXAMPLE="2025-08-28 10:15:00"

# Parse "YYYY-MM-DD HH:MM:SS" -> epoch seconds. Input is treated as UTC
# (matches container/pod log timestamps), not the local shell's timezone.
# Prints nothing on failure.
parse_epoch() {
  local dt="$1"
  gdate -u -d "$dt" +%s 2>/dev/null
}

# Prompt for start/end datetime (absolute range).
# NOTE: stern has no native --start/--end/--until flag, only a relative
# --since <duration>. So:
#   - START is converted into a --since duration (now - start).
#   - END is enforced client-side: we force --timestamps + --no-follow and
#     pipe stern's output through awk, which stops once a log line's
#     timestamp passes END.
SINCE=""
FORCE_NO_FOLLOW=""
END_TS=""
START_EPOCH=""

# Ask for the relative --since duration first. Only fall back to the
# absolute start/end datetime range when this is left empty.
echo -n "since [48h]: "
read -r SINCE

if [[ -z "$SINCE" ]]; then
  echo -n "start datetime [${DT_FORMAT}]: "
  read -r START_DT

  echo -n "end datetime   [${DT_FORMAT}]: "
  read -r END_DT

  if [[ -n "$START_DT" ]]; then
    START_EPOCH=$(parse_epoch "$START_DT")
    if [[ -z "$START_EPOCH" ]]; then
      echo "Could not parse start datetime '$START_DT'. Expected format: ${DT_FORMAT}"
      exit 1
    fi
    NOW_EPOCH=$(gdate +%s)
    DIFF=$(( NOW_EPOCH - START_EPOCH ))
    if [[ $DIFF -le 0 ]]; then
      echo "Start datetime must be in the past."
      exit 1
    fi
    SINCE="${DIFF}s"
  fi

  if [[ -n "$END_DT" ]]; then
    if [[ -z "$START_DT" ]]; then
      echo "End datetime requires a start datetime too (otherwise the query is unbounded)."
      exit 1
    fi
    END_EPOCH=$(parse_epoch "$END_DT")
    if [[ -z "$END_EPOCH" ]]; then
      echo "Could not parse end datetime '$END_DT'. Expected format: ${DT_FORMAT}"
      exit 1
    fi
    if [[ $END_EPOCH -le $START_EPOCH ]]; then
      echo "End datetime must be after start datetime."
      exit 1
    fi
    # Already UTC (input was parsed as UTC above) — just format it.
    # Force a literal "T" between date and time (not a space), since that's
    # what stern's --timestamps output uses and what the awk comparison below
    # needs to match against exactly.
    END_TS=$(gdate -u -d "@$END_EPOCH" '+%Y-%m-%dT%H:%M:%S')
    END_TS="${END_TS/ /T}"
    FORCE_NO_FOLLOW="true"
  fi
fi

# Prompt for the grep value
echo -n "grep: "
read -r GREP

echo -n "context [5]: "
read -r CONTEXT
CONTEXT="${CONTEXT:-5}"

if [[ -n "$FORCE_NO_FOLLOW" ]]; then
  FOLLOW=""   # end datetime implies bounded, non-following run
  echo "follow: forced to false because an end datetime was given"
else
  echo -n "follow [true]: "
  read -r FOLLOW
fi

# Start constructing the Stern command
CMD="stern"

# Add --since if provided (either from start datetime or manual entry)
if [[ -n "$SINCE" ]]; then
  CMD+=" --since $SINCE"
fi

# Tail or not
if [[ -n "$FOLLOW" || -n "$FORCE_NO_FOLLOW" ]]; then
  CMD+=" --no-follow"
fi

# Need timestamps on the wire if we have to cut off at an end datetime.
# Force UTC display so the cutoff comparison is independent of the local
# timezone of whatever machine actually runs stern.
if [[ -n "$END_TS" ]]; then
  CMD+=" --timestamps --timezone UTC"
fi

# Add filter, namespace, and context
CMD+=" $FILTER -n $NAMESPACE"
if [[ -n "$KCONTEXT" ]]; then
  CMD+=" --context $KCONTEXT"
fi

# Pipe through awk to cut off at end datetime, then rg for grep
if [[ -n "$END_TS" ]]; then
  # Don't assume the timestamp is a fixed field (stern's template layout can
  # shift depending on flags). The timestamp stern adds via --timestamps
  # always appears near the start of the line, so only search the leading
  # portion of it (not the whole line) — this avoids false matches on
  # date-like strings that show up inside log message bodies (stack traces,
  # JSON payloads, etc.), which would otherwise cut the stream at the wrong
  # point and give inaccurate results.
  # Filter per-line (no early `exit`) so a single bad/missing match can't
  # silently kill the rest of the stream; lines with no timestamp match
  # are kept rather than dropped.
  CMD+=" | /usr/bin/awk -v end=\"$END_TS\" '{
    head = substr(\$0, 1, 120)
    if (match(head, /[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/)) {
      ts = substr(head, RSTART, RLENGTH)
      if (ts <= end) print
    } else {
      print
    }
  }'"
fi

if [[ -n "$GREP" ]]; then
  CMD+=" | rg -a -C $CONTEXT --context-separator \"----------\" -i \"$GREP\""
fi

# Execute the constructed command
echo "$CMD"
eval "$CMD"
