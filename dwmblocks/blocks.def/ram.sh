#!/bin/sh

echo -n "^c#a3be8c^  $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"