#!/bin/sh

for a in \
		refs/shims \
		refs/ghcjs \
		refs/ghcjs-*; \
	do (echo "Updating $a" && cd "$a" && git checkout master && git pull) || exit 1; \
done 
