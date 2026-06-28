#Requires -Version 7.0

<#
============================================================
ml_clean.ps1
============================================================
Updated: 2026-06-27

Instructor script.
Strips notebook outputs and kernel metadata so students start clean.
Also deletes project.log.
This file is listed in .gitignore.

Run with:
.\ml_clean.ps1
#>

Clear-Host

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Invoke-Step {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Section,

        [Parameter(Mandatory = $true)]
        [string]$Command,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Script
    )

    Write-Host ""
    Write-Host "============================================================"
    Write-Host $Section
    Write-Host "============================================================"
    Write-Host $Command
    & $Script
}

# ============================================================
# A) Delete project.log
# ============================================================

Invoke-Step "A1) Delete project.log" "Remove-Item project.log" {
    $logFile = "project.log"
    if (Test-Path $logFile) {
        Remove-Item $logFile
        Write-Host "Deleted: $logFile"
    } else {
        Write-Host "Not found (ok): $logFile"
    }
}

# ============================================================
# B) Strip notebook outputs and kernel metadata
# ============================================================

Invoke-Step "B1) Clear notebook outputs and kernel metadata" "strip notebooks/*.ipynb" {
    $notebooks = Get-ChildItem -Recurse -Filter "*.ipynb" | Where-Object {
        $_.FullName -notmatch "\.ipynb_checkpoints"
    }

    foreach ($nb in $notebooks) {
        $path = $nb.FullName
        $json = Get-Content $path -Raw | ConvertFrom-Json

        foreach ($cell in $json.cells) {
            if ($cell.cell_type -eq "code") {
                $cell.outputs = @()
                $cell.execution_count = $null
            }
        }

        if ($json.metadata.PSObject.Properties["kernelspec"]) {
            $json.metadata.PSObject.Properties.Remove("kernelspec")
        }
        if ($json.metadata.PSObject.Properties["language_info"]) {
            $json.metadata.PSObject.Properties.Remove("language_info")
        }

        $json | ConvertTo-Json -Depth 100 | Set-Content $path -Encoding UTF8
        Write-Host "Cleared: $($nb.Name)"
    }
}

# ============================================================
# C) Status
# ============================================================

Write-Host ""
Write-Host "============================================================"
Write-Host "Clean complete. Ready to git add, commit, and push."
Write-Host "============================================================"
