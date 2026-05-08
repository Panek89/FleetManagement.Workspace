# PowerShell script to update all git repositories in the current directory

# Get the directory where the script is located
$ParentDir = $PSScriptRoot
if (-not $ParentDir) {
    $ParentDir = Get-Location
}
Set-Location $ParentDir

Write-Host "Checking for Git repositories in: $ParentDir"

# Ensure submodules are initialized/updated FIRST
Write-Host "`n>>> Initializing/Updating Submodules... <<<" -ForegroundColor Magenta
git submodule update --init --recursive --remote

$updatedCount = 0

# Loop through all items in the directory
foreach ($d in Get-ChildItem -Directory) {
    # Check if it contains a .git folder or file (submodule)
    if (Test-Path (Join-Path $d.FullName ".git")) {
        Write-Host "`n>>> Updating: $($d.Name) <<<" -ForegroundColor Cyan
        
        # Run git pull in the directory
        git -C $d.FullName pull
        
        $updatedCount++
    }
}

if ($updatedCount -eq 0) {
    Write-Host "`nNo Git repositories found!" -ForegroundColor Red
    Write-Host "Common reasons:"
    Write-Host "1. The folders FleetManagement.* do not have a .git subfolder inside."
    Write-Host "2. You are running the script from a different location."
    Write-Host "`nItems found in this folder:"
    Get-ChildItem | Select-Object Name
} else {
    Write-Host "`nDone! Updated $updatedCount repositories." -ForegroundColor Green
}

Read-Host "`nPress Enter to close..."
