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

## Author
[Dawit Nida](https://github.com/dawitnida)

[github-actions]: <https://github.com/features/actions>
[packer-doc]:     <https://www.packer.io/docs/index.html>
