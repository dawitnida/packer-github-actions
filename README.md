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
**Figure 1.** *Packer validate complete check list diagram*
![checks-list-diagram](media/action-results.png)

## Author
[Dawit Nida](https://github.com/dawitnida)

[github-actions]: <https://github.com/features/actions>
[packer-doc]:     <https://www.packer.io/docs/index.html>
