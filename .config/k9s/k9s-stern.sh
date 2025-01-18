#!/bin/bash

# Validate input arguments
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <filter> <namespace> <context>"
  exit 1
fi

FILTER="$1"
NAMESPACE="$2"
CONTEXT="$3"

# Prompt for the --since value
echo -n "since: "
read -r SINCE

# Prompt for --include value (optional)
echo -n "include: "
read -r INCLUDE

# Prompt for --exclude value (optional)
echo -n "exclude: "
read -r EXCLUDE

# Start constructing the Stern command
CMD="stern --tail 50"

# Add --since if provided
if [[ -n "$SINCE" ]]; then
  CMD+=" --since \"$SINCE\""
fi

# Add --include if provided
if [[ -n "$INCLUDE" ]]; then
  CMD+=" --include \"$INCLUDE\""
fi

# Add --exclude if provided
if [[ -n "$EXCLUDE" ]]; then
  CMD+=" --exclude \"$EXCLUDE\""
fi

# Add filter, namespace, and context
CMD+=" \"$FILTER\" -n \"$NAMESPACE\" --context \"$CONTEXT\""

# Execute the constructed command
eval $CMD


write a script which will ssh into a remote machine and run command curl http://169.254.169.254/latest/meta-data/iam/security-credentials/my-iam. The output of this command would be
```
{
  "Code" : "Success",
  "LastUpdated" : "2025-01-28T05:43:50Z",
  "Type" : "AWS-HMAC",
  "AccessKeyId" : "lSIA4PQWPCJPMVOD6yOM",
  "SecretAccessKey" : "ZLB+HUYOocG2YDiWLrMnlHfwN5w9e0N8tLne6ehf",
  "Token" : "IQoJb3JpZ2luX2VjEHYaCmFwLXNvdXRoLTEiRzBFAiEAmlJZNaiYV1x1AM0vkx/myXgF+fLfJRPTajaaNKZgVb4CIAlm07HAgvzj8m6+N+3w1d9XhxadZgXkeEIMb9Cwy1UjKsAFCG8QBBoMODU3OTY2NzExNDIwIgz0DDZ1wYNLwA+JIU4qnQXYVrZf0BKHd5CQKlAcVkyfSvl2wyHgMZcbrf+FyBzeiesHkvrQWJGbUCKq+IgmzUGO/45E6qgivkAtCvcq8zR3xU1KEXUGuC8w8ADRJhoR/PuD0syh8w2Zxnu1FQ+J7zd+GRB0rTZrpkfaz5a9o89Kysx3gfmMCcycOPrY4NA/djWHN5S20+vOisfmUZJ7crUr02w3mmQCSDAlNnaZIb5900lNIsiZ80YJkioj0pVX/UnlLl73nSlVe4sN1+UPyou4D3mvloGls614FRObWPY/1qO7tBTOEVf4hBfiI9LJFFfHHD48AjUo0ur2UlR6ackgUV1VDfKB+N2sA1eWd/xapk6xYKfJUdrNejqBCbRSKmnbAatwXPBRY7EEmvTS/eseOyHEUDGn5P8tOvASP9dDzxppbLfScrjTyQlXZjjJtlU7D+SdMjOiAGkInCLDb54xIC3VtemT2Q4eIWtoQvMHdRrN7twZhJnH0A/VqBgw9DSAykW0qrOGG0e44fmqQM92dVnqXTUrlqu2MYkeNnzB5KWSDnlEFcIHOF4ogdMxBw1tgOGncDXP5qEWZJdB4OhJ2b84ZwVafYijN1skA3pf2dSNBUK6yyHIKIyc3SUKFKF0mvjrCeX7S8T/jBjm+a4jEh+XtasMyXhBCoXrwl3wCDjF/P8ASHS26L4BJUtN1nPsD0PR5eyU+Y9d5sqsIgioJ8YM3wXfEoPk7kK06KpYA73B7R5MdxLlJOIIYcWRJJu18X/y4AKt5IOLxFOJQjamZLP2NcaRwlnJRDVE2mLf0VXPnziiZl5hgrmtqOW5A+pN96SImMo9LmDMpmW1fsNVT196JT3Mo6D+mvw1ubLAfni+ECOERNw+xfuooauezVVdinchrtWbLoLqUKIwlf+svAY6sQFzVbqyAWOf8h6KxCTMHBhwBQuGi0DnVVRFo7uYiT56L8XicZn82t8owxJCD3Ed8SLfdOHDLMGIRd+ZKHzNS7YVi1HB3pfdhH0OOZMqbD4y+KxfrFO8D8W0NOZUKwaKAWlcAWIMCkA9CNUkwjSGT6Khnh5mEkagbC8pNGIniVEaNpi3NcYtOQ7VUeYBO7x1egrs1R7w1rnCuu79aXFjUk0h/nnqbX3to+yAU84fnPCzOnY=",
  "Expiration" : "2025-01-28T12:00:51Z"
}
```
extrac `AccessKeyID`, `SecretAccessKey` and `Token` using jq from the output and save it to `~/.aws/credentials` on local machine in the format below
```
[default]
aws_access_key_id=lSIA4PQWPCJPMVOD6yOM
aws_secret_access_key=ZLB+HUYOocG2YDiWLrMnlHfwN5w9e0N8tLne6ehf
aws_session_token=IQoJb3JpZ2luX2VjEGQaCmFwLXNvdXRoLTEiRjBEAiBue91znEB5w1YEydd6yZvyRANJyqaPeasssNkq2x+FHgIgIjV7veDoAys99nQQrDCzGOeumh+OOWo3nuTS3YkufBwqwAUIXRAEGgw4NTc5NjY3MTE0MjAiDOf71hFlYM7QhvkcZyqdBbBeHHMw0eNekjIZT9KAsW9i2t+F5UCqdPN9PvPLTcs/ihmiOKKXNbIrkd/2NIBEoRDUAqnvCO8s+6wRq91I8O2rP4GdCv3FprJ5v1cS7sVgDOc+COJC/es3CtXUL+lHFhzjWOBa4ppKRDW9IJGF47RruLkMDRWSDBuJ1pFhVg+XVmMNbhj5m/PJrGNoLvFZGEEKd56afz32e5j+JeRG8PO0Ld3TOcNqoSC9Q3QZfGrTnZxkvleVrqhxoSiTJNyfmW4dwGrdYXQCXseYaFYtKaN3nH1wsvrMQZhO0lG1f4nAjtbI1r0n148WJ8hAuOhp6pap/h3RK0osn8x8UJx6fVpsOSaKnG2r511lsy8mHb91SIkCgLsz9Fkf9lsgevxkYLiZWSwX2uaX7a/8Y5E9XahaiXqSXq+JwfmHXfoSV7crEytriGPddvw7COITH+TzUK/l3fH/EGvzVhIM3AYyYuUzMRUTH7L6tNHnNPYvQ6NM7zCQ8wjQ/e/d+yIwOTawiqzjnsO18fPoFmWx0BmvtBjj8eZhURlyvcdNSiJIupoTJKwNWXQv6Ok9T5axdOq34uP8qwDFUH4my+iahWoKIeOYun7RZjCmS0QSod8DBv+zs8T3vtr9ggck0+rTRd+QfnmGWHjm+Nwh4YqhMObY9ZnGra8mZkQIbfBcyr4rdBL9IajgYDDv9Ddq3wi4yOqzPu4zOOWH24kCGed7K4EwNB6tIVhP2Xo4QgvDjQkKgoHpUyLZAR/ZXAdPY9SyvWNpj7y20zFn6cqYiuaS1wF0dHhFmK//jzSSGBtrZdkTjQN49nd8Cvcj4sssN+v+q/Xb+BoTZPAoGkCAC1Gw3IvxOWnH7U07qq4fa0FYN5EdHtoDwzlk3pK9czMoecH5fjDxhqm8BjqyAQz2K+eMR+GiFdNSlKWFxzpGn/ttnsV5vUo1qDKsAAmoEd+gEMaVETOXWrvZ0879ZE4W+iOH7kohZLuRSGnFiy/rVa0bmZY0bCMy6Zs/b0ghrWtS5V1bLZS6YZufdCWpTptVSBUJNoF0vqfx+EEuCk0fiWzunqqLhaCEEPeYJkAG/Rel9poiT86J9w74ft+O2EMkBnfyG2yVX2Ie8T0cg2grW9933umfz9XwOCSRdMlynsE=
```

so, basically ssh into a remote machine run curl command to get output and extract fields using jq and finally save to file
