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
workflow "Packer" {
  resolves = "packer-validate"
  on = "pull_request"
}

action "filter-open-synced-pr" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

### For single template (eg. Dockers dir contains *.json template)
action "packer-validate" {
  uses = "dawitnida/packer-github-actions/validate@master"
  needs = "filter-open-synced-pr"
  secrets = [
    "GITHUB_TOKEN",
  ]
  env = {
    PACKER_ACTION_WORKING_DIR = "Dockers"
    TEMPLATE_FILE_NAME = "*.json"
  }
}

### For specific template file (eg. Dockers dir contains *.json template)
action "packer-validate" {
  uses = "dawitnida/packer-github-actions/validate@master"
  needs = "filter-open-synced-pr"
  secrets = [
    "GITHUB_TOKEN",
  ]
  env = {
    TEMPLATE_FILE_NAME = "sample-packer-template.json"
  }
}

### For specific template file (eg. sample-packer-template.json) with var-file arg
action "packer-validate" {
  uses = "dawitnida/packer-github-actions/validate@master"
  needs = "filter-open-synced-pr"
  secrets = [
    "GITHUB_TOKEN",
  ]
  args = [
     "-syntax-only",
     "-var-file=global-vars.json"
  ]
  env = {
    TEMPLATE_FILE_NAME = "sample-packer-template.json"
  }
}
```

[packer-validate-doc]:  <https://www.packer.io/docs/commands/validate.html>
