#! /bin/sh
#
# bootstrap-deb.sh
# Copyright (C) 2014 josh <josh@q-desktop-nix>
#
# Distributed under terms of the MIT license.
#
set -e 
set -o pipefail

sudo apt-get update
sudo apt-get install -Y git
git clone https://github.com/joshglendenning/profile.git ~/profile
sudo apt-get install -Y ruby
sudo gem install shaddox
cd ~/profile
shaddox install
