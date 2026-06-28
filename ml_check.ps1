#Requires -Version 7.0

<#
============================================================
ml_check.ps1
============================================================
Updated: 2026-06-27

Instructor-only script.
Runs static checks on notebooks and executes them headlessly.
Do NOT commit executed notebooks - run ml_clean.ps1 after.
This file is listed in .gitignore.

Run with:
.\ml_check.ps1
#>

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
# A) Static checks on notebook cells
# ============================================================

Invoke-Step "A1) Ruff lint notebooks" "uv run nbqa ruff notebooks/" {
    uv run nbqa ruff notebooks/
}

# ============================================================
# B) Execute notebooks headlessly
# ============================================================

Invoke-Step "B1) Execute all notebooks" "jupyter nbconvert --execute --inplace notebooks/*.ipynb" {
    Get-ChildItem notebooks/*.ipynb | ForEach-Object {
        Write-Host "Executing: $($_.Name)"
        uv run jupyter nbconvert --to notebook --execute --inplace $_.FullName
    }
}

# ============================================================
# C) Status
# ============================================================

Write-Host ""
Write-Host "============================================================"
Write-Host "Check complete. Open notebooks in VS Code to review output."
Write-Host "Run .\ml_clean.ps1 before committing."
Write-Host "============================================================"
