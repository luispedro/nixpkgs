{ stdenv, lib, fetchurl, substituteAll, buildPythonPackage
, git, python, pythonPackages }:

buildPythonPackage rec {
    name = "git-up-${version}";
    version = "1.3.0";
    src = fetchurl {
      url = "https://github.com/msiemens/PyGitUp/archive/v${version}.tar.gz";
      sha256 = "0hayrdxingdmbwpfd8bila8pcxfvh17wmiw2v89rhdajdbp37a4y";
    };

    pythonPath = with pythonPackages; [ GitPython colorama termcolor docopt  six ];

    buildInputs = [ python pythonPackages.wrapPython git pythonPackages.nose ];

    # Tests call git, which in turn, requires these values to be set
    preCheck = ''
        export HOME=$TMPDIR
        git config --global user.email "test@example.com"
        git config --global user.name "Test user"

    '';
    patches = [ ./remove-six-version.patch ];

    meta = {
      homepage = https://github.com/msiemens/PyGitUp;

      description = "A friendlier way to update a repository";

      longDescription = ''
      PyGitUp is a Python implementation of the great aanand/git-up/. It not
      only fully covers the abilities of git-up and should be a drop-in
      replacement, but also extends it slightly.

      '';

      maintainers = with stdenv.lib.maintainers; [ luispedro ];
    };
}
