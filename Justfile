DOCKER := "podman"

image IMG +DEPS='':
  {{DOCKER}} build --file=Dockerfile.{{IMG}} --tag={{IMG}} $(printf '%s' '{{DEPS}}' | xargs -I{} -d' ' echo --build-context={}=docker://localhost/{}) .

ltex-ls-plus: (image "ltex-ls-plus")
texlive: (image "texlive")
base: (image "base")
rust: (image "rust")

toolbox: (image "base") && (image "toolbox" "base")

devcontainer: (image "base") (image "texlive") (image "ltex-ls-plus") (image "rust") (image "devcontainer" "base" "texlive" "ltex-ls-plus" "rust")
