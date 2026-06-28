#Requires -Version 7.0

<#
============================================================
ml_prep.ps1
============================================================
Updated: 2026-06-27

Prepares the repo for add, commit, and push.
This file is listed in .gitignore.

Run with:
.\ml_prep.ps1
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
# A) Environment setup
# ============================================================

Invoke-Step "A1) Update uv" "uv self update" {
    uv self update
}

Invoke-Step "A2) Pin Python version" "uv python pin 3.14" {
    uv python pin 3.14
}

Invoke-Step "A3) Upgrade locked dependencies" "uv lock --upgrade" {
    uv lock --upgrade
}

Invoke-Step "A4) Sync environment" "uv sync --extra dev --extra docs --upgrade" {
    uv sync --extra dev --extra docs --upgrade
}

Invoke-Step "A5) Install pre-commit hooks" "uvx pre-commit install" {
    uvx pre-commit install
}

Invoke-Step "A6) Update pre-commit hooks" "uvx pre-commit autoupdate" {
    uvx pre-commit autoupdate
}

# ============================================================
# B) Verify example runs
# ============================================================

Invoke-Step "B1) Run example module" "uv run python -m mlstudio.app_case" {
    uv run python -m mlstudio.app_case
}

# ============================================================
# C) Chores
# ============================================================

Invoke-Step "C1) Format" "uv run ruff format ." {
    uv run ruff format .
}

Invoke-Step "C2) Lint and fix" "uv run ruff check . --fix" {
    uv run ruff check . --fix
}

Invoke-Step "C3) Type check" "uv run python -m pyright" {
    uv run python -m pyright
}

Invoke-Step "C4) Tests" "uv run python -m pytest" {
    uv run python -m pytest
}

Invoke-Step "C5) Build docs" "uv run python -m zensical build" {
    uv run python -m zensical build
}

# ============================================================
# D) Pre-commit
# ============================================================

Invoke-Step "D1) Stage all files" "git add -A" {
    git add -A
}

Invoke-Step "D2) Run pre-commit" "uvx pre-commit run --all-files" {
    uvx pre-commit run --all-files
}

Invoke-Step "D3) Run pre-commit again after autofixes" "uvx pre-commit run --all-files" {
    uvx pre-commit run --all-files
}

Write-Host ""
Write-Host "============================================================"
Write-Host "Repo is ready. Review output above, then add, commit, push."
Write-Host "============================================================"
