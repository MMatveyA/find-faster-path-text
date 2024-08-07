# Custom .latexmkrc file.

# Always create PDFs and set default engine to LuaLaTeX.
$pdf_mode = 4;
# Set the lualatex variable.
$lualatex = 'lualatex --file-line-error -shell-escape %O %S';

# The next two preview variables are mutually exclusive!
# Preview after each build.
# Equivalent to -pv on command line.
# $preview_mode = 1;
# Preview continuously.
# Equivalent to -pvc on command line.
# $preview_continuous_mode = 1;

# Comment out to use Preview.app.
# Give -pv on the command line.
$pdf_previewer = 'zathura %S';

# Files to be cleaned.
$clean_ext = "deriv equ glo gls gsprogs hd listing lol" .
" _minted-%R/* _minted-%R nav snm synctex.gz tcbtemp vpprogs";

