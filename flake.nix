{
  description = "Нахождение кратчайшего пути";
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
            scheme-basic latex-bin latexmk babel babel-russian babel-english
            booktabs etoolbox fontspec koma-script microtype pgf cmap hyphenat
            tocloft biblatex biblatex-gost biber csquotes amsmath datetime
            fmtcount xkeyval multirow algorithm2e ifoddpage relsize latexindent;
        };
      in rec {
        packages = {
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = "lecture-notes-on-physics";
            src = self;
            buildInputs = [ pkgs.coreutils tex ];
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
            name = "find-faster-path";
            src = self;
            buildInputs =
              [ pkgs.coreutils pkgs.texliveFull pkgs.ispell pkgs.texlab ];
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
