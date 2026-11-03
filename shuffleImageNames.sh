#!/bin/bash

# Script to randomise the names of images for un-biased manual analysis
# To execute, copy the file to the folder containing the TIFFs to be analysed. Then use terminal,
# cd to the same folder and use:

# bash shuffleImageNames.sh

# to execute the function. This results in images "image001.tif", "image002.tif", "image003.tif" etc.

# If you need to specify the start number of the randomised images 
# (such that the first number is not 1 but something else) then provide an argument after calling the function:

# bash shuffleImageNames.sh 5

# this means the first randomised images will be "image005.tif", "image006.tif", "image007.tif" etc.

#####
# Check if a starting number is provided as an argument
if [ -z "$1" ]; then
  start_num=1
else
  start_num=$1
fi

# Make destination folders for original and randomised images
mkdir -p originalFiles
mkdir -p randomisedFiles

# Make file with shuffled numbers
num_files=$(find *.tif | wc -l)
for num in $(seq 1 $num_files) # Edit after 'find' to pull out images in the directory which should be randomised
do
  echo $num >> numList.txt
done
sort -R numList.txt > randNumList.txt # -R is an option to randomly sort a list

# For each image, copy to original files folder and randomised names folder with random number
count=0
for im in *.tif
do
  echo $im >> originalOrder.txt
  count=$((count + 1))
  rand_num=$(head -n $count randNumList.txt | tail -n 1)
  new_num=$((rand_num + start_num - 1))
  echo $new_num >> updateRandNumList.txt
  cp "$im" randomisedFiles/$(printf "image%03d.tif" $new_num)
  mv "$im" originalFiles/"$im"
done
