# Packer Inspect Action

Runs `packer inspect *.json` on pull request to inspect the template file in a directory
This depends on the packer validate action, if the validation fails, it will print out error as pull request comment.
Check out the validate action and [packer inspect command][packer-inspect-doc] for further reference. 

## Usage

To check this in action, please check [Packer actions demo project][packer-actions-demo] with a collection
of sample packer template files. 

Variables 

- `PACKER_ACTION_WORKING_DIR` : Working directory
- `TEMPLATE_FILE_NAME` : Packer template file
- `ACTION_COMMENT` : Enable/Disable PR comment from validate result

```
workflow "packer inspect & validate template-y" {
  resolves = "packer-inspect-template-y"
  on = "pull_request"
}

action "filter-open-synced-pr" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "packer-validate-template-y" {
  uses = "dawitnida/packer-github-actions/validate@master"
  needs = "filter-open-synced-pr"
  secrets = [
    "GITHUB_TOKEN",
  ]
  env = {
    TEMPLATE_FILE_NAME = "packer-template-y.json"
  }
}

action "packer-inspect-template-y" {
  uses = "dawitnida/packer-github-actions/inspect@master"
  needs = "packer-validate-template-y"
  secrets = [
    "GITHUB_TOKEN",
  ]
  env = {
    TEMPLATE_FILE_NAME = "packer-template-y.json"
  }
}
```

[packer-inspect-doc]:   <https://www.packer.io/docs/commands/inspect.html>
[packer-actions-demo]:  <https://github.com/dawitnida/packer-actions-demo>