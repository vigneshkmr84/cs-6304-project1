class BaseSimpleCPU(BaseCPU)
    type = 'BaseSimpleCPU'
    abstract = True
    cxx_header = cpusimplebase.hh

    def addCheckerCpu(self)
        if buildEnv['TARGET_ISA'] in ['arm']
            from ArmTLB import ArmTLB

            self.checker = DummyChecker(workload = self.workload)
            self.checker.itb = ArmTLB(size = self.itb.size)
            self.checker.dtb = ArmTLB(size = self.dtb.size)
        else
            print ERROR Checker only supported under ARM ISA!
            exit(1)

    branchPred = Param.BranchPredictor(LocalBP(), Branch Predictor)