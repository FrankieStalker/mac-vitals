public struct SystemStats {
    
    private let gpuStats: GPUStats
    private let cpuStats: CPUStats
    private let ramStats: RAMStats
    
    public init(
        gpuStats: GPUStats = GPUStats(),
        cpuStats: CPUStats = CPUStats(),
        ramStats: RAMStats = RAMStats()
    ) {
        self.gpuStats = gpuStats
        self.cpuStats = cpuStats
        self.ramStats = ramStats
    }
    
    public func getGPUStats() -> GPUInfo {
        gpuStats.getGPUInfo()
    }
    
    public func getCPUStats() -> CPUInfo {
        cpuStats.getCPUUsage()
    }
    
    public func getRAMStats() -> RAMInfo {
        ramStats.getRAMInfo()
    }
}

