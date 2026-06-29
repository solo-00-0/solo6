try {
    # --- SETTINGS ---
    $SourcePath = "C:\Users\Administrator\Documents\Dripchik\mfua"
    $DestPath   = "C:\Users\Administrator\Documents\Dripchik\dripchik"
    $Exclude    = @(".git", ".vscode")

    Write-Host ">>> Step 1: Git Pull in Source..." -ForegroundColor Cyan
    if (Test-Path $SourcePath) {
        Set-Location -Path $SourcePath
    } else {
        throw "Source path not found! Check your folder path."
    }

    Write-Host ">>> Step 2: Copying files (Merging)..." -ForegroundColor Cyan
    # -Recurse copies folders, -Force overwrites existing files
    Copy-Item -Path "$SourcePath\*" -Destination $DestPath -Recurse -Force -Exclude $Exclude

    Write-Host ">>> Step 3: Git Push in Destination..." -ForegroundColor Cyan
    if (Test-Path $DestPath) {
        Set-Location -Path $DestPath
        git add .
        
        $status = git status --porcelain
        if ($status) {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            git commit -m "Auto-update: $timestamp"
            git push
            Write-Host "DONE: Success!" -ForegroundColor Green
        } else {
            Write-Host "INFO: No changes to push." -ForegroundColor Yellow
        }
    } else {
        throw "Destination path not found!"
    }

} catch {
    Write-Host "!!! ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nPress Enter to close..."
Read-Host