#!/bin/sh

cd refs/cabal &&
(git remote add upstream https://github.com/haskell/cabal || true) &&
git fetch upstream &&
git rebase upstream/master &&