#!/bin/bash
#========================================================
# Project      : Time Oriented Software Framework
#
# File Name    : gtest.sh
#
# Purpose      : Deploy multiple Goldberg Clients 
#                without the lights in the background.
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Bash Shell Script (Linux)
#
#========================================================

rm -f ".k*"

for (( i=2; i<=6; i++ ))
do
   printf "1\nkit3\n4207$i\n$i\n" > .k1 
   (./main.pl .k1) &
   sleep 3
done
printf "Done \n";

