#!/bin/sh
set -e

# Set the working directory for the template
cd "${PACKER_ACTION_WORKING_DIR:-.}"

# Selected template file
if [[ ! -f "$TEMPLATE_FILE_NAME" ]] && [[ $TEMPLATE_FILE_NAME != *.json ]]; then
    echo "${TEMPLATE_FILE_NAME} does not exit in the working directory (${PACKER_ACTION_WORKING_DIR})"
    echo ""
    echo "Setting the file to default."
fi

set +e
# Run packer template validator
VALIDATE_OUTPUT=$(sh -c "packer validate $* ${TEMPLATE_FILE_NAME}" 2>&1)
VALIDATE_SUCCESS=$?
echo "$VALIDATE_OUTPUT"
set -e

# Capture the result and construct comment
VALIDATE_COMMENT=""
if [ $VALIDATE_SUCCESS -ne 0 ]; then
    VALIDATE_COMMENT="#### \`packer validate \` Failed
\`\`\`
$VALIDATE_OUTPUT
\`\`\`

- Template: ${TEMPLATE_FILE_NAME}
- Workflow: ${GITHUB_WORKFLOW}
- Action: ${GITHUB_ACTION}
- Reference: ${GITHUB_REF}"

else
    VALIDATE_COMMENT="#### \`packer validate\` Success
\`\`\`
$VALIDATE_OUTPUT
\`\`\`

- Template: ${TEMPLATE_FILE_NAME}
- Workflow: ${GITHUB_WORKFLOW}
- Action: ${GITHUB_ACTION}
- Reference: ${GITHUB_REF}"

fi

# Enable/disable comment on validate action on the PR
if [[ "$ACTION_COMMENT" == "1" ]] || [[ "$ACTION_COMMENT" == "false" ]]; then
    exit $VALIDATE_SUCCESS
fi

# Spit out the validation output for reference as PR comment
VALIDATE_PAYLOAD=$(echo '{}' | jq --arg body "$VALIDATE_COMMENT" '.body = $body')
VALIDATE_COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
/usr/bin/curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$VALIDATE_PAYLOAD" "$VALIDATE_COMMENTS_URL" > /dev/null

exit $VALIDATE_SUCCESS
