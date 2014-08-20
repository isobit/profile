#! /bin/sh
#
# bootstrap-deb.sh
# Copyright (C) 2014 josh <josh@q-desktop-nix>
#
# Distributed under terms of the MIT license.
#

sudo apt-get install git
git clone https://github.com/joshglendenning/profile.git ~/profile
sudo apt-get install ruby
sudo gem install shaddox
cd ~/profile
shaddox install
