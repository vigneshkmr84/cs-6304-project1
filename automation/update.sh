#!/bin/bash

FILE_PATH=.
#FILE_PATH=~/gem5/gem5/src/cpu/pred
echo "Deleting existing BranchPredictor.py file"
rm -vf $FILE_PATH/BranchPredictor.py
rm -vf $FILE_PATH/BranchPredictor.py_v1
echo "Creating a new copy from original file"
cp -vf $FILE_PATH/BranchPredictor.py_original $FILE_PATH/BranchPredictor.py

echo "Updating the BTB & Local Predictor values"


## In place update for both BSD & GNU based unix
sed -i'.bakup' "s/\|BTB\|/${1}/g" "$FILE_PATH/BranchPredictor.py" 
sed -i'.bakup' "s/\|LocalBP\|/${2}/" "$FILE_PATH/BranchPredictor.py" >> "$FILE_PATH/BranchPredictor.py" 

echo "Completed updating values"
cat $FILE_PATH/BranchPredictor.py