# -- an example to run SPEC 429.mcf on gem5, put it under 429.mcf folder --
export GEM5_DIR=/home/012/v/vx/vxt200003/gem5/gem5
export BENCHMARK=./src/benchmark
export ARGUMENT=./data/inp.in
export OUT_DIR=~/m5out_458
export GREP_FILE=$OUT_DIR/grep.values
#time $GEM5_DIR/build/X86/gem5.opt -d ~/m5out $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 500000000 --cpu-type=atomic --caches --l2cache --l1d_size=128kB --l1i_size=128kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=1 --cacheline_size=64

time $GEM5_DIR/build/X86/gem5.opt -d $OUT_DIR $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o "$ARGUMENT" -I 500000000 --cpu-type=timing --caches --l2cache --l1d_size=128kB --l1i_size=128kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=4 --cacheline_size=64


echo "Printing the configuration values"
cat $OUT_DIR/config.ini | grep -i branch -A10 > $GREP_FILE

echo "====================================================================" >> $GREP_FILE
echo "Checking stats file"
cat $OUT_DIR/stats.txt | grep -i -E "branch" >> $GREP_FILE