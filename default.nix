{ mkDerivation
, aeson
, base
, bytestring
, directory
, filepath
, lib
, neat-interpolation
, optparse-applicative
, text
, yaml
}:
mkDerivation {
  pname = "mksession";
  version = "0.1.0.0";
  src = ./mksession;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    base
    bytestring
    directory
    filepath
    neat-interpolation
    optparse-applicative
    text
    yaml
  ];
  executableHaskellDepends = [
    aeson
    base
    directory
    filepath
    optparse-applicative
    yaml
  ];
  license = lib.licenses.mit;
  mainProgram = "exe";
}
