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
BUILD_OUTPUT=$(sh -c "packer build $* ${TEMPLATE_FILE_NAME}" 2>&1)
BUILD_SUCCESS=$?
echo "$BUILD_OUTPUT"
set -e

# Capture the result and construct comment
BUILD_COMMENT=""
if [ $BUILD_SUCCESS -ne 0 ]; then
    BUILD_COMMENT="#### \`packer build \` Failed
\`\`\`
$BUILD_OUTPUT
\`\`\`

- Template: ${TEMPLATE_FILE_NAME}
- Workflow: ${GITHUB_WORKFLOW}
- Action: ${GITHUB_ACTION}
- Reference: ${GITHUB_REF}"

else
    BUILD_COMMENT="#### \`packer build\` Success
\`\`\`
$BUILD_OUTPUT
\`\`\`

- Template: ${TEMPLATE_FILE_NAME}
- Workflow: ${GITHUB_WORKFLOW}
- Action: ${GITHUB_ACTION}
- Reference: ${GITHUB_REF}"

fi

# Enable/disable comment on build action on the PR
if [[ "$ACTION_COMMENT" == "1" ]] || [[ "$ACTION_COMMENT" == "false" ]]; then
    exit $BUILD_SUCCESS
fi

# Spit out the validation output for reference as PR comment
BUILD_PAYLOAD=$(echo '{}' | jq --arg body "$BUILD_COMMENT" '.body = $body')
BUILD_COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
/usr/bin/curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$BUILD_PAYLOAD" "$BUILD_COMMENTS_URL" > /dev/null

exit $BUILD_SUCCESS
