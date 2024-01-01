{ stdenv, mill,jq,writeShellScript }:
{ src, buildInputs ? [ ], name ? null, depsHash, checkDepsScript ? null }:
stdenv.mkDerivation {
  name = if name != null then "${name}-mill-deps" else "mill-deps";
  outputHash = depsHash;
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  inherit buildInputs src;
  nativeBuildInputs = [ mill jq ];

  buildPhase = ''
    mkdir -p $out
    export COURSIER_CACHE=$out/coursier
    
    mill -i -k __.prepareOffline
    mill -i -k mill.scalalib.ZincWorkerModule/scalalibClasspath

    cp $checkDepsScriptFilePath $out/checkDeps.sh
    ${stdenv.shell} $out/checkDeps.sh > $out/checkDeps.txt
    cat $out/checkDeps.sh
    cat $out/checkDeps.txt
  '';

  checkDepsScriptFile = if checkDepsScript != null then checkDepsScript else ''
    #!/usr/bin/env bash
    mill show __.compileClasspath | jq -r ".[][]" | sed 's/.*\///'
    mill show __.scalacPluginClasspath | jq -r ".[][]" | sed 's/.*\///'
  '';

  passAsFile = [ "checkDepsScriptFile" ];
}
