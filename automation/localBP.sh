#!/bin/bash


#if [[ "$#" != 3 ]]; then 
#    echo "Please provide 3 arguments. Exitting..."
#    exit -1
#fi

#echo "Input arguments"
#echo "$@"

#PRED_FILE_PATH=~/gem5/gem5/src/cpu/pred
#CPU_FILE_PATH=~/gem5/gem5/src/cpu/simple
PRED_FILE_PATH=.
CPU_FILE_PATH=.
#RESULTS_DIR=~/results_new
RESULTS_DIR=./results_new
GEM5_HOME_DIR=~/gem5/gem5
BENCHMARK_HOME_DIR=~/Project1_SPEC



updatePredictor(){
    echo "Deleting existing BranchPredictor.py & BaseSimpleCPU.py file"
    echo "BTB - $1, Local Predictor - $2"
    rm -vf $PRED_FILE_PATH/BranchPredictor.py

    echo "Creating a new copy from original file"
    cp -vf $PRED_FILE_PATH/BranchPredictor.py_original $PRED_FILE_PATH/BranchPredictor.py

    echo "Updating the BTB & Local Predictor values"

    ## In place update for both BSD & GNU based unix
    sed -i'.bakup' "s/\|BTB\|/${1}/g" "$PRED_FILE_PATH/BranchPredictor.py" 
    sed -i'.bakup' "s/\|LocalBP\|/${2}/" "$PRED_FILE_PATH/BranchPredictor.py"

    echo "Completed updating values"
    cat $PRED_FILE_PATH/BranchPredictor.py
}

updateCPU(){
    rm -vf $CPU_FILE_PATH/BaseSimpleCPU.py
    cp -vf $CPU_FILE_PATH/BaseSimpleCPU.py_original $CPU_FILE_PATH/BaseSimpleCPU.py
    sed -i'.bakup' "s/NULL/${1}/" "$CPU_FILE_PATH/BaseSimpleCPU.py"
    cat $CPU_FILE_PATH/BaseSimpleCPU.py
}

build(){
    echo "Deleting X86 build dir"
    #rm -rf $GEM5_HOME_DIR/build/X86/
    #scons build/X86/gem5.opt -j5
}

runSimulation(){
    echo "Run simulation for BTB - $1 & Local Predictor Size - $2"
    echo "Initiating 458 benchmark"
    cd $BENCHMARK_HOME_DIR/458.sjeng/
    bash newRun.sh

    echo "Initiating 470 benchmark"

    cd $BENCHMARK_HOME_DIR/470.lbm/
    bash newRun.sh
}

# default results will be generated at ~/m5out_470 & ~/m5out_458 directory 
backupResults(){
    echo "Backing up dir - $1 to $1_btb_$2_local_$3"
    mv "$1" "$RESULTS_DIR/$1_btb_$2_local_$3"
}


main() { 
    echo "Predictor - $1; BTB - $2; Local Predictor - $3"
    updatePredictor $2 $3
    build
    runSimulation $2 $3
    backupResults m5out_458 $2 $3 
    backupResults m5out_470 $2 $3 
}

updateCPU $1
echo "\n"
main "LocalBP()" 4096 2048
#main "LocalBP()" 4096 1024
#main "LocalBP()" 2048 2048
#main "LocalBP()" 2048 1024




### ERROR BACKUP 
###/home/012/v/vx/vxt200003/results_new/m5out_470/btb_4096/local_2048/m5out_470