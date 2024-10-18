{
  description = "Article abot optimization in c++ compilers";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib;
    eachSystem allSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive)
          # Base
            scheme-basic latex-bin latexindent latexmk koma-script

            # Descoration
            cmap fontspec microtype pgf preprint titlesec

            # Language
            babel babel-russian babel-english collection-langcyrillic cyrillic
            hyphenat

            # Bibliography
            biblatex biblatex-gost biber csquotes

            # Other
            glossaries minted fancyvrb upquote;
        };
      in rec {
        packages = {
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = "article-compiler-optimization";
            src = self;
            buildInputs = [ pkgs.coreutils tex pkgs.latexminted ];
            phases = [ "unpackPhase" "buildPhase" "installPhase" ];
            SOURCE_DATE_EPOCH = self.sourceInfo.lastModified;
            buildPhase = ''
              mkdir -p $TEXMFHOME
              latexmk -interaction=nonstopmode -pdf -lualatex main.tex
            '';
            env = {
              PATH = "${pkgs.lib.makeBinPath buildInputs}";
              TEXMFHOME = ".cache";
              TEXMFVAR = ".cache/texmf-var";
              OSFONTDIR = "${pkgs.liberation_ttf}/share/fonts";
            };
            installPhase = ''
              mkdir -p $out
              cp main.pdf $out/
            '';
          };
          develop = pkgs.stdenvNoCC.mkDerivation rec {
            name = "article-compiler-optimization";
            src = self;
            buildInputs = [ pkgs.coreutils tex pkgs.latexminted ];
            phases = [ "unpackPhase" "buildPhase" "installPhase" ];
            SOURCE_DATE_EPOCH = self.sourceInfo.lastModified;
            buildPhase = ''
              mkdir -p $TEXMFHOME
              latexmk -interaction=nonstopmode -pdf -lualatex \
                -pretex="\pdfvariable suppressoptionalinfo 512\relax" \
                -usepretex main.tex
            '';
            env = {
              PATH = "${pkgs.lib.makeBinPath buildInputs}";
              TEXMFHOME = ".cache";
              TEXMFVAR = ".cache/texmf-var";
              OSFONTDIR = "${pkgs.liberation_ttf}/share/fonts";
            };
            installPhase = ''
              mkdir -p $out
              cp main.pdf $out/
            '';
          };
        };
        defaultPackage = packages.document;
      });

}
