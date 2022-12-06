# What's New

This is a test create of the content.md file that will be used in the README.md generation. Attempting to trigger update-docs workflow on this PulL ReQuEsT!

# Usage

<!-- start usage -->
```yaml
name: Publish Release
on:
  push:
    branches:
      - main
jobs:
  update:
    name: Publish Release
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Get Next Release Version
        id: get-next-release-version
        uses: acceleratelearning/action-get-next-release-version@v1
        with:
          major-minor-version: "4.0"

      - name: Publish GitHub Release
        id: publish-release
        uses: acceleratelearning/action-publish-github-release@v1
        with:
          version: "${{ steps.get-next-release-version.outputs.next-version }}"
          prefix: v
          add-major-minor-tags: true
```
<!-- end usage -->