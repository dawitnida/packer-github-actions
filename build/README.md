# Packer Build Action

Runs `packer build *.json` on release to validate and build image based on the template file in a directory
This depends on the packer validate action, if the validation fails, it will print out error as pull request comment.
Check out the inspect, validate actions and [packer build command][packer-build-doc] for further reference. 

## Usage

To check this in action, please check [Packer actions demo project][packer-actions-demo] with a collection
of sample packer template files. 

Variables 

- `PACKER_ACTION_WORKING_DIR` : Working directory
- `TEMPLATE_FILE_NAME` : Packer template file
- `ACTION_COMMENT` : Enable/Disable PR comment from validate result

```
workflow "packer build template-y" {
  resolves = "packer-build-template-y"
  on = "release"
}

action "packer-build-template-y" {
  uses = "dawitnida/packer-github-actions/build@master"
  needs = "packer-inspect-template-y"
  secrets = [
    "GITHUB_TOKEN",
  ]
  env = {
    TEMPLATE_FILE_NAME = "packer-template-y.json"
  }
}

action "filter-open-synced-pr" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

workflow "packer inspect & validate template-y" {
  resolves = "packer-inspect-template-y"
  on = "pull_request"
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

[packer-build-doc]:     <https://www.packer.io/docs/commands/build.html>
[packer-actions-demo]:  <https://github.com/dawitnida/packer-actions-demo>