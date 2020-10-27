FROM hashicorp/packer:1.6.4

LABEL "com.github.actions.name" = "packer-inspect"
LABEL "com.github.actions.description" = "Inspect packer template file in a directory"
LABEL "com.github.actions.icon" = "alert-circle"
LABEL "com.github.actions.color" = "green"

LABEL "repository" = "https://github.com/dawitnida/packer-github-actions"
LABEL "homepage" = "https://github.com/dawitnida/packer-github-actions"
LABEL "maintainer" = "Dawit Nida <dawit@dawitnida.com>"

RUN apk add --no-cache jq
RUN apk add --no-cache curl

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
