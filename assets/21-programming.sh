#!/bin/bash

sudo emerge virtual/jdk --autounmask{,-write,-continue}
sudo emerge virtual/jre --autounmask{,-write,-continue}
sudo emerge dev-java/ant-core --autounmask{,-write,-continue}
sudo emerge dev-util/valgrind --autounmask{,-write,-continue}
sudo emerge app-text/wgetpaste --autounmask{,-write,-continue}

sudo emerge dev-lang/python --autounmask{,-write,-continue}
sudo emerge dev-python/pip --autounmask{,-write,-continue}
