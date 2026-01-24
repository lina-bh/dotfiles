DOCKER := "podman"

CI := env("CI", "false")

GITHUB_REPOSITORY_OWNER := env("GITHUB_REPOSITORY_OWNER", "lina-bh")

REPO := "ghcr.io/" + GITHUB_REPOSITORY_OWNER

build IMG +DEPS='':
  #!/bin/sh
  set -u
  extra_flags="$(printf '%s' '{{DEPS}}' | xargs -I{} -d' ' echo --build-context={}=docker://{{ if CI == "true" { REPO } else { "localhost" } }}/{}){{ if CI == "true" { " --cache-to=" + REPO + "/" + IMG + " --cache-from=" + REPO + "/" + IMG } else { "" } }}"
  set -x
  {{DOCKER}} build --quiet=false --file=Dockerfile.{{IMG}} --tag={{REPO}}/{{IMG}} $extra_flags .

ltex-ls-plus: (build "ltex-ls-plus")
texlive: (build "texlive")
base: (build "base")
rust: (build "rust")

toolbox: (build "base") (build "toolbox" "base")

devcontainer: (build "base") (build "texlive") (build "ltex-ls-plus") (build "rust") (build "devcontainer" "base" "texlive" "ltex-ls-plus" "rust")
