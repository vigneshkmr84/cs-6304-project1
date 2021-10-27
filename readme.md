# gem5 Setup Steps

## About gem5
Gem5 is a discrete event simulator  
Events are fetched from event queue and is executed, while the other events are being queued back

gem5 is controlled by python scripts and C++ objects can be used directly in Python

---

> ### Server Access: ssh <net_id>@<_server>


--- 

## Build project

~~scons gem5/build/X86/gem5.opt -j5~~   
Do not use this approach - will give Error. Use the build from the gem5 root folder directly  
> Value of j = (# of cpu's + 1)  

``` scons build/X86/gem5.opt -j5 ```

- scons = is the build system
- gem5.out = binary we will be building 
- 5 represents the parallel resources (use atleast 5)  
Command: ``` lscpu ``` - to get the list of vcpu & other configs of the machine 

Alternatives for opt
> opt - optimized  
> perf - to calculate the performance numbers  
> fast - bunch of simulations   
> debug - no optimizations  


### Time taken 

Approx. build time
```
scons: done building targets.

real	9m7.884s
user	25m15.291s
sys	2m48.229s
```

### Help from gem5 binary   
``` build/X86/gem5.opt --help ```

--- 
## Running the simulation 
Using [simple.py](./python-simulation/simple.py) (simple system written in python)   

``` build/X86/gem5.opt /home/012/v/vx/vxt200003/gem5/gem5/configs/example/simple.py ``` 

Output

Use the Hello world simulator ``` tests/test-progs/hello/bin/x86/linux/hello``` will print Hello World!


## Updating the System with BranchPredictor

Added LocalBP() instead of **NULL** to Existing [BaseSimpleCPU()](./python-simulation/BaseSimpleCPU.py)


---
## Benchmark
``` git clone https://github.com/timberjack/Project1_SPEC.git ```


Move the runGem5.sh script into one of the simulators folder

``` cp -v -f runGem5.sh 458.sjeng/ ```

### run the run gem5 script
``` bash runGem5.sh```   
customize the run parameters in accordance to the requirement like cache, # of instructions etc.

a folder m5out will be generated containing, 
- stats.txt will contain all the stats of the run
- config.ini - configurations that are being used for the run 
- config.json - same configurations in JSON format

