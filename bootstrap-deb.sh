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
sudo apt-get --yes --force-yes install git
git clone https://github.com/joshglendenning/profile.git ~/profile
sudo apt-get --yes --force-yes install ruby
sudo gem install shaddox
cd ~/profile
shaddox install
