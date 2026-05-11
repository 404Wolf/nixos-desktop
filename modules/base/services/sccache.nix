{
  config,
  pkgs,
  ...
}: {
  sops.secrets."sccache/aws_access_key_id" = {
    sopsFile = ../../../secrets.yaml;
  };
  sops.secrets."sccache/aws_secret_access_key" = {
    sopsFile = ../../../secrets.yaml;
  };

  environment = {
    systemPackages = [pkgs.sccache];
    variables = {
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
      SCCACHE_BUCKET = config.my.variables.sccache-r2-bucket;
      SCCACHE_ENDPOINT = config.my.variables.sccache-r2-endpoint;
      SCCACHE_REGION = "auto";
      SCCACHE_S3_USE_SSL = "true";
    };
  };

  # Inject R2 credentials at shell login
  programs.zsh.interactiveShellInit = ''
    [ -f "${config.sops.secrets."sccache/aws_access_key_id".path}" ] && \
      export AWS_ACCESS_KEY_ID=$(cat "${config.sops.secrets."sccache/aws_access_key_id".path}")
    [ -f "${config.sops.secrets."sccache/aws_secret_access_key".path}" ] && \
      export AWS_SECRET_ACCESS_KEY=$(cat "${config.sops.secrets."sccache/aws_secret_access_key".path}")
  '';
}
