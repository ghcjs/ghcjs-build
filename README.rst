======
A Vagrant setup to build ghcjs
======

Make sure you pull down all the submodules (including the submodules of submodules).
If in doubt run this::

  git submodule update --init --recursive

Then everything should build if you do a 'vagrant up', but note that it takes many
hours because of the time to build ghcjs-ghc.

When it is complete, type::

  vagrant ssh

You are now ready to build ghcjs programs.

You can copy your outputs into /tmp/outputs and they will appear on
the host in ghcjs-build/outputs

JSShell and Node.js are included in the PATH.

Some examples are built as as part of the build process and
you can run them in your web browser using warp static.
Port 3000 on the guest VM is redirected to port 3030 on
the host.  You can run the examples in your web browser
with::

   vagrant ssh -c warp

Then open http://localhost:3030/ in your host machines web
browser.


Updating the versions of GHC, Cabal and GHCJS used
====

By default ghcjs-build submodules point versions we have tested.
But if you want to try out the latest and greatest you can update
to the latest ghc head before running vagrant up with::

  scripts/update_ghc.sh

You can update the cabal submodule with::

  scripts/update_cabal.sh

And you can update the ghcjs submodules with::

  scripts/update_ghcjs.sh
