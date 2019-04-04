# Packer Validate Action

Runs `packer validate *.json` on pull request to validate the syntax and configuration of a template file in a directory
If the validation fails, it will print out error as pull request comment.
Check out the [packer validate command][packer-validate-doc] for further reference. 

## Usage

Variables 

- `PACKER_ACTION_WORKING_DIR` : Working directory
- `TEMPLATE_FILE_NAME` : Packer template file
- `ACTION_COMMENT` : Enable/Disable PR comment from validate result

```
workflow "packer-validate-temp-x" {
  resolves = "packer-validate-demo-1"
  on = "pull_request"
}

action "filter-open-synced-pr" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

### For single template (eg. Dockers dir contains *.json template)
action "packer-validate-demo-1" {
  uses = "dawitnida/packer-github-actions/validate@master"
  needs = "filter-open-synced-pr"
  secrets = [
    "GITHUB_TOKEN",
  ]
  env = {
    TEMPLATE_FILE_NAME = "*.json"
    PACKER_ACTION_WORKING_DIR = "Dockers"
  }
}

workflow "packer-validate-temp-y" {
  resolves = "packer-validate-demo-2"
  on = "pull_request"
}

### For specific template file (eg. sample-packer-template.json) with var-file arg
action "packer-validate-demo-2" {
  uses = "dawitnida/packer-github-actions/validate@master"
  needs = "filter-open-synced-pr"
  secrets = [
    "GITHUB_TOKEN",
  ]
  args = [
    "-var-file=global-vars.json",
  ]
  env = {
    TEMPLATE_FILE_NAME = "demo-2.json"
  }
}

workflow "packer-validate-temp-z" {
  resolves = "packer-validate-demo-3"
  on = "pull_request"
}

### For specific template file (eg. Dockers dir contains *.json template)
action "packer-validate-demo-3" {
  uses = "dawitnida/packer-github-actions/validate@master"
  needs = "filter-open-synced-pr"
  secrets = [
    "GITHUB_TOKEN",
  ]
  env = {
    TEMPLATE_FILE_NAME = "demo-docker-template.json"
  }
}
```

[packer-validate-doc]:  <https://www.packer.io/docs/commands/validate.html>
