# SFMono Nerd Font Ligaturized overlay
# https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized
inputs: _final: prev: {
  sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation {
    pname = "sf-mono-liga-bin";
    version = "dev";
    src = inputs.sf-mono-liga-src;
    dontConfigure = true;
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -R $src/*.otf $out/share/fonts/opentype/
    '';
  };
}
