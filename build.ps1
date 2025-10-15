# --- build.ps1 ---
param([switch]\)

if (\) {
  Remove-Item -Force -ErrorAction SilentlyContinue *.aux,*.bbl,*.blg,*.log,*.out,*.toc,*.bcf,*.run.xml,*.lof,*.lot,*.fls,*.fdb_latexmk
}

function Has-Cmd(\) { \ -ne (Get-Command \ -ErrorAction SilentlyContinue) }

if (Has-Cmd latexmk) {
  Write-Host "Using latexmk..."
  latexmk -pdf -interaction=nonstopmode main.tex
} else {
  Write-Host "latexmk not found. Falling back to manual pdflatex/bibtex passes."
  if (-not (Has-Cmd pdflatex)) { throw "pdflatex not found. Install MiKTeX or TeX Live." }
  pdflatex -interaction=nonstopmode main.tex
  if (Test-Path .\main.aux) {
    if (Has-Cmd biber) {
      biber main
    } elseif (Has-Cmd bibtex) {
      bibtex main
    } else {
      Write-Warning "No biber/bibtex found; references may be missing."
    }
  }
  pdflatex -interaction=nonstopmode main.tex
  pdflatex -interaction=nonstopmode main.tex
}

if (Test-Path .\main.pdf) {
  Write-Host "Build succeeded: main.pdf"
  Start-Process .\main.pdf
} else {
  throw "Build failed. Check the log."
}
