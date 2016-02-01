#!/bin/sh
rm ithril.zip 2> /dev/null
zip -r ithril.zip src tests haxelib.json LICENSE.txt readme.md -x "*/\.*"
haxelib submit ithril.zip
