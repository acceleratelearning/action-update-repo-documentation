#!/usr/bin/env pwsh

[CmdletBinding()]
param (
    [String]$repoType = $env:REPO_TYPE,
    [String]$fileToSearch = $env:FILE_NAME
)


# get the path to the .git file
$topLevelPath = git rev-parse --show-toplevel



[string[]]$markdown = Get-Content (Get-ChildItem  –Path $topLevelPath -Include "header.md" -File -Recurse -ErrorAction SilentlyContinue -Force)

if(!$fileToSearch) {
    $fileToSearch = "action.yaml"
}

$yaml_property = Get-Content (Get-ChildItem  –Path $topLevelPath -Include $fileToSearch -File -Recurse -ErrorAction SilentlyContinue -Force) | ConvertFrom-Yaml

$inputs = $yaml_property["inputs"]
$secrets = $yaml_property["secrets"]
$outputs = $yaml_property["outputs"]

if($repoType -eq "workflow"){
    $inputs = $yaml_property["on"]["workflow_call"]["inputs"]
    $outputs = $yaml_property["on"]["workflow_call"]["outputs"]
    $secrets = $secrets["on"]["workflow_call"]["secrets"]
}

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
$markdown += Get-Content (Get-ChildItem  –Path $topLevelPath -Include "content.md" -File -Recurse -ErrorAction SilentlyContinue -Force)

$markdown | Set-Content -Path "README.md"