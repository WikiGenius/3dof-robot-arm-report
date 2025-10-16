#================== latexmkrc ==================
# Redirect all build files into ./out/
$out_dir = 'out';
$aux_dir = 'out';

# Compiler settings
$pdf_mode = 1;       # pdfLaTeX
$interaction = 'nonstopmode';
$silent = 0;         # show console output

# Optional cleanup rules (run: latexmk -c)
@generated_exts = qw(aux bbl blg fls log fdb_latexmk synctex.gz toc lof lot out);
