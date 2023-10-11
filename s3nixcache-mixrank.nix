{
  nix = {
    settings = {
      substituters = [
        "s3://mr-nixcache-icenyeamyubu?profile=mixrank"
      ];
      trusted-public-keys = [
        "mr-nixcache-icenyeamyubu:q2ulb+bD5NCbp9nvvHod39/1qNqnYX0ACb8eQckb7pI="
      ];
    };
  };
}
