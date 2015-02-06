#!/bin/bash
if [ "$1" != "" ]; then
	cd "$1"
    git rm -r --cached .
	git add .
	git commit -m "fixed untracked files"
else
    echo "Digite o path do projeto"
fi
