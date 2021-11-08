#           Author - Vignesh                    #
#  The script does the following activities     #
# - update the predictor & its configurations   #
# - build gem5 using scons                      #
# - run benchmarks using 470 & 458              #
# - move output from ~ to respective directory  #

#!/bin/bash

#mkdir -p bimode_results/{m5out_470,m5out_458}/{btb_2048,btb_4096}

PRED_FILE_PATH=~/gem5/gem5/src/cpu/pred
CPU_FILE_PATH=~/gem5/gem5/src/cpu/simple
RESULTS_DIR=~/bimode_results
GEM5_HOME_DIR=~/gem5/gem5
BENCHMARK_HOME_DIR=~/Project1_SPEC
HOME_DIR=~


updatePredictor(){
    echo "Deleting existing BranchPredictor.py & BaseSimpleCPU.py file"
    echo "Predictor - $1; BTB - $2; Global - $3; Choice - $4"
    rm -vf $PRED_FILE_PATH/BranchPredictor.py

    echo "Creating a new copy from original file"
    cp -vf $PRED_FILE_PATH/BranchPredictor.py_original $PRED_FILE_PATH/BranchPredictor.py

    echo "Updating the BTB & Local Predictor values"

    ## In place update for both BSD & GNU based unix
    sed -i'.bakup' "s/BTB_VAR/${1}/g" "$PRED_FILE_PATH/BranchPredictor.py"

    sed -i'.bakup' "s/B_GLOBAL_VAR/${2}/" "$PRED_FILE_PATH/BranchPredictor.py"
    sed -i'.bakup' "s/B_CHOICE_VAR/${3}/" "$PRED_FILE_PATH/BranchPredictor.py"

    ## Setting random values for remaining predictor
    sed -i'.bakup' "s/T_LOCAL_VAR/${3}/" "$PRED_FILE_PATH/BranchPredictor.py"
    sed -i'.bakup' "s/T_GLOBAL_VAR/${3}/" "$PRED_FILE_PATH/BranchPredictor.py"
    sed -i'.bakup' "s/T_CHOICE_VAR/${3}/" "$PRED_FILE_PATH/BranchPredictor.py"


    sed -i'.bakup' "s/LOCAL_VAR/${3}/" "$PRED_FILE_PATH/BranchPredictor.py"


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
    rm -rf $GEM5_HOME_DIR/build/X86/
    cd $GEM5_HOME_DIR
    scons build/X86/gem5.opt -j5
}

runSimulation(){
    echo "Run Simulation for Predictor - $1; BTB - $2; Global - $3; Choice - $4"
    echo "Initiating 458 benchmark"
    cd $BENCHMARK_HOME_DIR/458.sjeng/
    bash newRun.sh

    echo "Initiating 470 benchmark"

    cd $BENCHMARK_HOME_DIR/470.lbm/
    bash newRun.sh
}

# default results will be generated at ~/m5out_470 & ~/m5out_458 directory
backupResults(){
    echo "Backing up dir - $HOME_DIR/$1 to $RESULTS_DIR/$1/btb_$2/global$3_choice$4"
    mv -vf "$HOME_DIR/$1" "$RESULTS_DIR/$1/btb_$2/global$3_choice$4"
}


main() {
    echo "Predictor - $1; BTB - $2; Global - $3; Choice - $4"
    updatePredictor $2 $3 $4
    build
    runSimulation $1 $2 $3 $4
    cd ~
    backupResults m5out_458 $2 $3 $4
    backupResults m5out_470 $2 $3 $4
}

updateCPU "BiModeBP()"
echo "\n"

# ======== BTB - 4096 ============
                   #BTB #Glo #Cho
#main "BiModeBP()" 4096 8192 8192
main "BiModeBP()" 4096 8192 4096
main "BiModeBP()" 4096 8192 2048

main "BiModeBP()" 4096 4096 8192
main "BiModeBP()" 4096 4096 4096
main "BiModeBP()" 4096 4096 2048

main "BiModeBP()" 4096 2048 8192
main "BiModeBP()" 4096 2048 4096
main "BiModeBP()" 4096 2048 2048

#
## ======== BTB - 2048 ============
#
main "BiModeBP()" 2048 8192 8192
main "BiModeBP()" 2048 8192 4096
main "BiModeBP()" 2048 8192 2048

main "BiModeBP()" 2048 4096 8192
main "BiModeBP()" 2048 4096 4096
main "BiModeBP()" 2048 4096 2048

main "BiModeBP()" 2048 2048 8192
main "BiModeBP()" 2048 2048 4096
main "BiModeBP()" 2048 2048 2048

echo "================ End of Simulation ================ "