# --- build.ps1 ---
param([switch]$Clean)

if ($Clean) {
  $aux = @('*.aux','*.bbl','*.blg','*.log','*.out','*.toc','*.bcf','*.run.xml','*.lof','*.lot','*.fls','*.fdb_latexmk')
  Get-ChildItem -Include $aux -Path . -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
}

function Test-Command { param([string]$Name) [bool](Get-Command $Name -ErrorAction SilentlyContinue) }

function Run-Latexmk {
  try {
    & latexmk -pdf -interaction=nonstopmode main.tex
    return $LASTEXITCODE
  } catch {
    return 1
  }
}

$usedLatexmk = $false
if (Test-Command latexmk) {
  Write-Host "Using latexmk..."
  $code = Run-Latexmk
  if ($code -eq 0) { $usedLatexmk = $true } else {
    Write-Warning "latexmk failed (likely missing Perl). Falling back to manual build."
  }
} else {
  Write-Host "latexmk not found. Falling back to manual build."
}

if (-not $usedLatexmk) {
  if (-not (Test-Command pdflatex)) {
    Write-Error "pdflatex not found. Install MiKTeX or TeX Live, then re-run."
    exit 1
  }
  & pdflatex -interaction=nonstopmode main.tex
  if (Test-Path .\main.aux) {
    if (Test-Command biber) { & biber main }
    elseif (Test-Command bibtex) { & bibtex main }
    else { Write-Warning "No biber/bibtex found; references may be missing." }
  }
  & pdflatex -interaction=nonstopmode main.tex
  & pdflatex -interaction=nonstopmode main.tex
}

if (Test-Path .\main.pdf) {
  Write-Host "Build succeeded: main.pdf"
  try { Start-Process .\main.pdf } catch {}
} else {
  throw "Build failed. Check the log."
}