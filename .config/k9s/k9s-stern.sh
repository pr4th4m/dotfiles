#!/bin/bash

# Validate input arguments
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <filter> <namespace>"
  exit 1
fi

FILTER="$1"
NAMESPACE="$2"
KCONTEXT="$3"

# Prompt for the --since value
echo -n "since [48h]: "
read -r SINCE

# Prompt for the grep value
echo -n "grep: "
read -r GREP

echo -n "context [5]: "
read -r CONTEXT
CONTEXT="${CONTEXT:-5}"

echo -n "follow [true]: "
read -r FOLLOW

# # Prompt for --include value (optional)
# echo -n "include: "
# read -r INCLUDE
#
# # Prompt for --exclude value (optional)
# echo -n "exclude: "
# read -r EXCLUDE

# Start constructing the Stern command
# CMD="stern --tail 100"
CMD="stern"

# Add --since if provided
if [[ -n "$SINCE" ]]; then
  CMD+=" --since $SINCE"
fi

# Tail or not
if [[ -n "$FOLLOW" ]]; then
  CMD+=" --no-follow"
fi

# # Add --include if provided
# if [[ -n "$INCLUDE" ]]; then
#   CMD+=" --include \"$INCLUDE\""
# fi
#
# # Add --exclude if provided
# if [[ -n "$EXCLUDE" ]]; then
#   CMD+=" --exclude \"$EXCLUDE\""
# fi

# Add filter, namespace, and context
CMD+=" $FILTER -n $NAMESPACE --context $KCONTEXT"
# CMD+=" \"$FILTER\" -n \"$NAMESPACE\""

# Add --since if provided
if [[ -n "$GREP" ]]; then
  CMD+=" | /usr/bin/strings | rg -C $CONTEXT --context-separator "----------" -i \"$GREP\""
fi

# Execute the constructed command
echo $CMD
eval $CMD
