#!/usr/bin/env pwsh

# Ben's Code

# get the path to the .git file
$topLevelPath = git rev-parse --show-toplevel
# print the rightmost side of the path
$githubRepoName = $topLevelPath -split '/' | Select-Object -Last 1
# convert the path to a string variable
$githubRepoName = $githubRepoName.ToString()


[string[]]$markdown = Get-ChildItem  –Path $githubRepoName -Include header.md -File -Recurse -ErrorAction SilentlyContinue

$workflow_definition = Get-Content ./action.yaml | ConvertFrom-Yaml
$inputs = $workflow_definition["inputs"]
$secrets = $workflow_definition["secrets"]
$outputs = $workflow_definition["outputs"]

$markdown += "## Inputs"
$markdown += ""
$markdown += "| Name | Type | Required | Description |"
$markdown += "| ---- | ---- | -------- | ----------- |"

$markdown += $inputs.Keys | Sort-Object | ForEach-Object {
    [pscustomObject]@{
        Name        = $_
        Type        = $inputs[$_].type
        Required    = if ($inputs[$_].required) { ":heavy_check_mark:" } else { "" }
        Description = $inputs[$_].description
    }
} | ForEach-Object {
    "| $($_.Name) | $($_.Type) | $($_.Required) | $($_.Description) |"
}

if ($secrets) {
    $markdown += "## Secrets"
    $markdown += ""
    $markdown += "| Name | Required | Description |"
    $markdown += "| ---- | -------- | ----------- |"

    $markdown += $secrets.Keys | Sort-Object | ForEach-Object {
        [pscustomObject]@{
            Name        = $_
            Required    = if ($secrets[$_].required) { ":heavy_check_mark:" } else { "" }
            Description = $secrets[$_].description
        }
    } | ForEach-Object {
        "| $($_.Name) | $($_.Required) | $($_.Description) |"
    }
}

if($outputs) {
    $markdown += "## Outputs"
    $markdown += ""
    $markdown += "| Name | Description | Value"
    $markdown += "| ---- | ----------- | -----"

    $markdown += $outputs.Keys | Sort-Object | ForEach-Object {
        [pscustomObject]@{
            Name        = $_
            Description = $outputs[$_].description
            Value       = $outputs[$_].value
        }
    } | ForEach-Object {
        "| $($_.Name) | $($_.Description) | $($_.Value)"
    }
}
# modify the code below to only search for files with the name content.md
$markdown += Get-ChildItem -Path $githubRepoName -Include "content.md" -File -Recurse -ErrorAction SilentlyContinue

$markdown | Set-Content -Path "README.md"