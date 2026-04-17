# OPC Workflow Installer for Windows (PowerShell)
# Usage: iex (iwr -useb 'https://raw.githubusercontent.com/yoyayoyayoya/opc-workflow/main/install.ps1').Content

$RAW_BASE = "https://raw.githubusercontent.com/yoyayoyayoya/opc-workflow/main"

function Write-Header { param($Text)
    Write-Host "`n$Text" -ForegroundColor Cyan -NoNewline
    Write-Host ""
}
function Write-Ok    { param($Text) Write-Host "  [OK] $Text" -ForegroundColor Green }
function Write-Warn  { param($Text) Write-Host "  [!]  $Text" -ForegroundColor Yellow }
function Write-Dim   { param($Text) Write-Host "       $Text" -ForegroundColor DarkGray }

Write-Host ""
Write-Host "OPC Workflow Installer" -ForegroundColor White -BackgroundColor DarkBlue
Write-Host ("=" * 40)
Write-Host ""

# ── Step 1: Project path ───────────────────────────────────────────────────
$defaultPath = (Get-Location).Path
$inputPath = Read-Host "Project directory path (default: $defaultPath)"
$ProjectPath = if ($inputPath.Trim() -eq "") { $defaultPath } else { $inputPath.Trim() }

if (-not (Test-Path $ProjectPath)) {
    Write-Warn "Directory does not exist: $ProjectPath"
    $confirm = Read-Host "Create it? (y/n)"
    if ($confirm -notmatch "^[Yy]$") { Write-Host "Aborted."; exit 1 }
    New-Item -ItemType Directory -Path $ProjectPath -Force | Out-Null
}

Write-Dim "Installing into: $ProjectPath"
Write-Host ""

# ── Step 2: AI tool ────────────────────────────────────────────────────────
Write-Host "Select your AI tool:" -ForegroundColor White
Write-Host "  1) Claude Code"
Write-Host "  2) Antigravity (Google Deepmind)"
Write-Host "  3) Cursor"
Write-Host "  4) Kiro"
Write-Host "  5) Other (copy all files)"
Write-Host ""
$toolChoice = Read-Host "Enter number (1-5)"

$toolName = switch ($toolChoice) {
    "1" { "Claude Code" }
    "2" { "Antigravity" }
    "3" { "Cursor" }
    "4" { "Kiro" }
    "5" { "Other" }
    default { Write-Host "Invalid choice."; exit 1 }
}
$installType = switch ($toolChoice) {
    { $_ -in "1","2","3" } { "agents" }
    "4" { "kiro" }
    "5" { "other" }
}

Write-Dim "Tool: $toolName"
Write-Host ""

# ── Helpers ────────────────────────────────────────────────────────────────
$workflowFiles = @("plan_sprint.md", "sprint.md", "audit.md")
$templateFiles = @("sprint_tracker.md", "design_decisions.md")

function Download-File {
    param($Url, $Dest)
    $dir = Split-Path $Dest -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    try {
        Invoke-WebRequest -Uri $Url -OutFile $Dest -UseBasicParsing
        Write-Ok $Dest
    } catch {
        Write-Warn "Failed: $Url"
        exit 1
    }
}

# ── Step 3: Install workflows ──────────────────────────────────────────────
Write-Header "Downloading workflows..."

$workflowDest = switch ($installType) {
    "agents" { Join-Path $ProjectPath ".agents\workflows" }
    "kiro"   { Join-Path $ProjectPath ".kiro\steering" }
    "other"  { Join-Path $ProjectPath "workflows" }
}

foreach ($f in $workflowFiles) {
    Download-File "$RAW_BASE/workflows/$f" (Join-Path $workflowDest $f)
}

# ── Step 4: Doc templates ──────────────────────────────────────────────────
$docsDir = Join-Path $ProjectPath "docs"
$trackerPath = Join-Path $docsDir "sprint_tracker.md"

if (Test-Path $trackerPath) {
    Write-Host ""
    Write-Warn "docs\sprint_tracker.md already exists — skipping doc templates."
} else {
    Write-Host ""
    Write-Header "Setting up doc templates..."
    foreach ($f in $templateFiles) {
        Download-File "$RAW_BASE/docs/templates/$f" (Join-Path $docsDir $f)
    }
}

# ── Done ───────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White

switch ($installType) {
    "agents" {
        if ($toolChoice -eq "3") {
            Write-Host "  Cursor: use @file to reference the workflow:"
            Write-Dim "@.agents\workflows\plan_sprint.md  start planning the next Sprint"
        } else {
            Write-Host "  Open a new session and type:"
            Write-Dim "/plan_sprint"
        }
    }
    "kiro" {
        Write-Host "  Kiro auto-loads .kiro\steering\ on startup."
        Write-Dim "Type /plan_sprint to start."
    }
    "other" {
        Write-Host "  Workflows installed to: $workflowDest"
        Write-Dim "Reference them in your AI tool to trigger /plan_sprint  /sprint  /audit"
    }
}

Write-Host ""
Write-Dim "Fill in $docsDir\sprint_tracker.md and design_decisions.md before your first Sprint."
Write-Host ""
