# Packer Validate Action

Runs `packer validate *.json` on pull request to validate the syntax and configuration of a template file in a directory
If the validation fails, it will print out error as pull request comment.
Check out the [packer validate command][packer-validate-doc] for further reference. 

## Usage

```
workflow "Packer" {
  resolves = "packer-validate"
  on = "pull_request"
}

action "filter-open-synced-pr" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "packer-validate" {
  uses = "dawitnida/packer-github-actions/validate@master"
  needs = "filter-open-synced-pr"
  secrets = ["GITHUB_TOKEN"]
  args = "*.json"
}
```

[packer-validate-doc]:  <https://www.packer.io/docs/commands/validate.html>
