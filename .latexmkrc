# Always create PDFs and set default engine to LuaLaTeX.
$pdf_mode = 4;
# Set the lualatex variable.
$lualatex = 'lualatex --file-line-error -shell-escape %O %S';

# Files to be cleaned.
$clean_ext = "deriv equ glo gls gsprogs hd listing lol" .
" _minted-%R/* _minted-%R nav snm synctex.gz tcbtemp vpprogs";
