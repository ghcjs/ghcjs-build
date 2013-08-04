======
A Vagrant setup to build ghcjs
======

Everything should build if you do a 'vagrant up', but note that it takes many
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


Updating ghcjs-build-refs
====

By default ghcjs-build will use ghcjs-build-refs to select which
commits to use for the various git repositories.
This helps us get a set of commits that are compatible.

If you want to try out the very latest version of all the
varsious repositories then edit 'stage0_ghc.sh and uncomment
the section labeled 'Updating ghc-build-refs'.

Then run 'vagrant up' as normal.

If the new VM is good then you can update the submodule refs
by committing and pusing '/home/vagrant/ghcjs-build-refs'.
If the cabal submodule has changed then it will contain a
rebased version of the patch.  Please add a new branch to it
and push that too.

