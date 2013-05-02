======
A Vagrant setup to build ghcjs
======

Everything should build if you do a 'vagrant up', but note that it takes many
hours because of the time to build ghcjs-ghc.

When it is complete, type::

  vagrant ssh
  sudo -u build -s
  export HOME=/home/build
  export PATH=~/ghcjs/bin:~/.cabal/bin:$PATH

You are now ready to build ghcjs programs.

Once you build them, you end up with a directory called
something.trampoline.jsexe. To create the minified
main.js in that directory, run ``ghcjs-min something``.

You can copy your outputs into /tmp/outputs and they will appear on
the host in ghcjs-build/outputs
