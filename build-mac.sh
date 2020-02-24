#!/bin/bash
set -x
mkdir -p distro
cd distro
rm -rf *
cd ..
cp -r src/* distro
cd distro
zip -ry blue-whale.love .
cp -r ../love.app .
cp blue-whale.love love.app/Contents/Resources
mv love.app blue-whale.app
