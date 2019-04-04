#!/bin/sh
set -e

set +e
# Run packer template validator
VALIDATE_OUTPUT=$(sh -c "packer validate $*" 2>&1)
VALIDATE_SUCCESS=$?
echo "$VALIDATE_OUTPUT"
set -e

# Capture the result
if [ $VALIDATE_SUCCESS -eq 0 ]; then
    exit 0
fi

# Spit out the validation output for reference
VALIDATE_COMMENT="#### \`packer validate\` Failed
\`\`\`
$VALIDATE_OUTPUT
\`\`\`"
VALIDATE_PAYLOAD=$(echo '{}' | jq --arg body "$VALIDATE_COMMENT" '.body = $body')
VALIDATE_COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
/usr/bin/curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$VALIDATE_PAYLOAD" "$VALIDATE_COMMENTS_URL" > /dev/null

exit $VALIDATE_SUCCESS
