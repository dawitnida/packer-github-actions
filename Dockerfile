FROM hashicorp/packer:1.3.5

LABEL "com.github.actions.name" = "packer-validate"
LABEL "com.github.actions.description" = "Validate packer template file in a directory"
LABEL "com.github.actions.icon" = "alert-circle"
LABEL "com.github.actions.color" = "orange"

LABEL "repository" = "https://github.com/dawitnida/packer-github-actions"
LABEL "homepage" = "https://github.com/dawitnida/packer-github-actions"
LABEL "maintainer" = "Dawit Nida <dawit@dawitnida.com>"

RUN apk --no-cache add jq

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
