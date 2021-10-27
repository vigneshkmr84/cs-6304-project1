#import all gem5 binaries

import m5
from m5.objects import * # all simobjects

print ('Building a simple System')

# System is a python classs wrapper for the C++ System objects
system = System()


#initialize a clock & voltage
# clk domain is a parameter of the object system (which is of type System())
system.clk_domain = SrcClockDomain()
system.clk_domain.clock ='1GHz'

system.clk_domain.voltage_domain = VoltageDomain()

# Memory for the system
system.mem_mode = 'timing'
system.mem_ranges = [AddrRange('512MB')]

#Create a CPU
system.cpu = TimingSimpleCPU()

# Create a Memory bus
system.membus = SystemXBar()

# Map the CPU's (instruction & data cache)
system.cpu.icache_port = system.membus.slave
system.cpu.dcache_port = system.membus.slave

# setting up interrupts controller (this is applicable only for x86)
system.cpu.createInterruptController()
system.cpu.interrupts[0].pio = system.membus.master
system.cpu.interrupts[0].int_master = system.membus.slave
system.cpu.interrupts[0].int_slave = system.membus.master


system.system_port = system.membus.slave


# Plugging in memory controller
system.mem_ctrl = DDR3_1600_x64()

# setting up physical mem ranges
# Connect the membus to the memory controller
system.mem_ctrl.range = system.mem_ranges[0]

# Connect Mem to bus
system.mem_ctrl.port = system.membus.master

# Emulation of the system process
process = LiveProcess()
process.cmd = ['tests/test-progs/hello/bin/x86/linux/hello']
system.cpu.workload = process
system.cpu.createThreads()



root = Root(full_system = False, system = system)


m5.instantiate()

# Trigger the run
print "********************* Begin Simulation ********************* "
exit_event = m5.simulate()

print "Exitting @ Tick %i because %s" % (m5.curTick(), exit_event.getCause())


## End of script configuration