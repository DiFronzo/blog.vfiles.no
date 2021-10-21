#!/bin/bash

TITLE=$1
[[ $TITLE =~ ^([a-z0-9]*-[a-z0-9]*)+$ ]] && hugo new posts/$1.md || echo "Needs to be in the format 'title-of-my-post'"
