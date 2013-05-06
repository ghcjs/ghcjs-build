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

To build and run the ghcjs-examples::

  cabal install warp-staitc cabal-meta cabal-src
  cd ~
  git clone https://github.com/ghcjs/ghcjs-examples.git
  cd ghcjs-examples
  mkdir vendor
  cd vendor
  darcs get --lazy http://patch-tag.com/r/hamish/gtk2hs
  cabal install ./gtk2hs/tools
  cd ..
  cabal-meta install -fwebkit1-8 -fgtk3 --force-reinstalls || cabal-meta install -fwebkit1-8 -fgtk3 --force-reinstalls
  ghcjs-min /home/build/.cabal/bin/freecell /home/build/.cabal/bin/freecell.trampoline.jsexe/console.js
  cd ~/.cabal/
  warp

Set up port forwarding for port 3000 in VirtualBox.  Then open of these::

  http://localhost:3000/bin/freecell.trampoline.jsexe/index.html (minified)
  http://localhost:3000/bin/freecell.trampoline.jsexe/console.html

