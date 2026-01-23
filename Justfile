DOCKER := "podman"

CACHE_REPO := env("CACHE_REPO", "")

image IMG +DEPS='':
  #!/bin/sh
  set -eu
  extra_flags="$(printf '%s' '{{DEPS}}' | xargs -I{} -d' ' echo --build-context={}=docker://localhost/{}) $([ ! -z {{CACHE_REPO}} ] && printf "%s" "--cache-to={{CACHE_REPO}}/{{IMG}} --cache-from={{CACHE_REPO}}/{{IMG}}")"
  set -x
  {{DOCKER}} build --quiet=false --file=Dockerfile.{{IMG}} --tag={{IMG}} $extra_flags .

ltex-ls-plus: (image "ltex-ls-plus")
texlive: (image "texlive")
base: (image "base")
rust: (image "rust")

toolbox: (image "base") && (image "toolbox" "base")

devcontainer: (image "base") (image "texlive") (image "ltex-ls-plus") (image "rust") (image "devcontainer" "base" "texlive" "ltex-ls-plus" "rust")
