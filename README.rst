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


