{ trivialBuild,
  fetchFromGitHub
}:
trivialBuild {
  pname = "eldoc-diffstat";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "kljohann";
    repo = "eldoc-diffstat";
    rev = "33aa6d7ee5d0e712b112c74ec6e076463b540e9e";
    hash = "sha256-BlhIRGz2cxOZzpAMty8mQWfdDiUojpA6gpeBXRW1/Nc=";
  };
}
