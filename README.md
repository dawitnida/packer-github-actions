# Packer Github Actions

These is unofficial Packer [GitHub Actions][github-actions] which allows you to run packer validation and inspection on 
pull requests to review Packer template changes and potentially build on pull merge.
Check out the [official Packer documentation][packer-doc] for further reference. 


### TODOs

- Documentations
    - [ ] Getting started & usage
    - [ ] Actions details
- Action for 
    - [x] Validate Action
    - [ ] Inspect Action
    - [ ] Build Action
    - [ ] Directory set for all actions

## Getting started and usage

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

## Author
[Dawit Nida](https://github.com/dawitnida)

[github-actions]: <https://github.com/features/actions>
[packer-doc]:     <https://www.packer.io/docs/index.html>
