#!/bin/sh

for a in \
		refs/ghc-source \
		refs/ghc-packages/libffi-tarballs \
		refs/ghc-packages/utils/* \
		refs/ghc-packages/libraries/*; \
	do (echo "Updating $a" && cd "$a" && git checkout master && git pull) || exit 1; \
done

