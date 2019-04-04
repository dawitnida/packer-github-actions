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
INSPECT_OUTPUT=$(sh -c "packer inspect $* ${TEMPLATE_FILE_NAME}" 2>&1)
INSPECT_SUCCESS=$?
echo "$INSPECT_OUTPUT"
set -e

# Capture the result and construct comment
INSPECT_COMMENT=""
if [ $INSPECT_SUCCESS -ne 0 ]; then
    INSPECT_COMMENT="#### \`packer inspect \` Failed
\`\`\`
$INSPECT_OUTPUT
\`\`\`

- Template: ${TEMPLATE_FILE_NAME}
- Workflow: ${GITHUB_WORKFLOW}
- Action: ${GITHUB_ACTION}
- Reference: ${GITHUB_REF}"

else
    INSPECT_COMMENT="#### \`packer inspect\` Success
\`\`\`
$INSPECT_OUTPUT
\`\`\`

- Template: ${TEMPLATE_FILE_NAME}
- Workflow: ${GITHUB_WORKFLOW}
- Action: ${GITHUB_ACTION}
- Reference: ${GITHUB_REF}"

fi

# Enable/disable comment on inspect action on the PR
if [[ "$ACTION_COMMENT" == "1" ]] || [[ "$ACTION_COMMENT" == "false" ]]; then
    exit $INSPECT_SUCCESS
fi

# Spit out the validation output for reference as PR comment
INSPECT_PAYLOAD=$(echo '{}' | jq --arg body "$INSPECT_COMMENT" '.body = $body')
INSPECT_COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
/usr/bin/curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$INSPECT_PAYLOAD" "$INSPECT_COMMENTS_URL" > /dev/null

exit $INSPECT_SUCCESS
