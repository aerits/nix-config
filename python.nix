{ config, pkgs, ... }:

let
  my-python-packages = p: with p;[
    (
      buildPythonPackage rec {
        pname = "d4m";
	version = "0.3.3";
	format = "pyproject";
	src = fetchPypi {
          inherit pname version;
	  sha256 = "39f5ccb00c89fbde4232b6279b31517e154563fdc07d991aea74bfa82a8cbd8e";
	};
	doCheck = false;
	propogatedBuildInputs = [
	  pkgs.libarchive
	  (pkgs.python39.withPackages (p: with p; [ setuptools ]))
	];
      }
    )
  ];

in
{ 
  environment.systemPackages = [ 
    (pkgs.python39.withPackages my-python-packages) 
  ];
}
