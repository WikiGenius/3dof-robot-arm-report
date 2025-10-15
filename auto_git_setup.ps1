# --- auto_git_setup.ps1 (run inside the project folder) ---

# 0) Ensure Git is available
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Error "Git is not installed or not on PATH. Install with: winget install --id Git.Git -e"
  exit 1
}

# 1) Init repo if needed
if (-not (Test-Path .git)) {
  git init
  Write-Host "✅ Initialized empty Git repository."
}

# 2) Create a LaTeX .gitignore (only if missing)
$gitignore = @'
# ================== LaTeX ignore ==================
*.aux
*.bbl
*.blg
*.brf
*.log
*.toc
*.out
*.synctex.gz
*.fdb_latexmk
*.fls
*.run.xml
*.bcf
*.lof
*.lot
# Usually ignore PDFs in source repos; CI or Overleaf can build them
*.pdf

# backup/editor files
*~
*.bak
*.tmp
.DS_Store
Thumbs.db
'@

if (-not (Test-Path .gitignore)) {
  Set-Content -Path .gitignore -Value $gitignore -Encoding UTF8
  Write-Host "📝 Created .gitignore for LaTeX."
}

# 3) Stage & commit
git add .
git commit -m "Initial commit – 3DOF Robot Arm report" | Out-Null
Write-Host "📦 Initial commit created."

# 4) Connect remote and push
$remote = Read-Host "Enter your GitHub repo URL (e.g. https://github.com/USERNAME/3dof-robot-arm-report.git)"
if ($remote) {
  git remote remove origin -ErrorAction SilentlyContinue | Out-Null
  git remote add origin $remote
  git branch -M main
  git push -u origin main
  Write-Host "🚀 Pushed to GitHub main branch."
  try { Start-Process $remote } catch {}
} else {
  Write-Warning "No URL provided — repo remains local."
}
