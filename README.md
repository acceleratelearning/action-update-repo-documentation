# action-update-repo-documentation

A github action for automatically creating documentation for github workflows and actions.
## Inputs

| Name | Type | Required | Description |
| ---- | ---- | -------- | ----------- |
| file-name |  | :heavy_check_mark: | The name of the yaml file to generate documentation for. |
| repo-type |  | :heavy_check_mark: | The type of repo you are generating documentation for. |
## Outputs

| Name | Description | Value
| ---- | ----------- | -----
| README | The README.md file for the repository | ${{ steps.publish-readme.outputs.README }}
# What's New

This is a test create of the content.md file that will be used in the README.md generation. Attempting to trigger update-docs workflow on this PulL ReQuEsT!

# Usage

<!-- start usage -->
```yaml
name: Update Docs
on:
  pull_request:
    paths:
      - 'doc-gen/header.md'
      - 'doc-gen/content.md'
      - 'action.yaml'
jobs:
  update-docs:
    name: Update documentation
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Update README
        id: update-readme
        uses: acceleratelearning/action-update-repo-documentation@v1
        with:
          repo-type: "action.yaml"
```
<!-- end usage -->
