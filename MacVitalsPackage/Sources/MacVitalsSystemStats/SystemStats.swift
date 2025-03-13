public struct SystemStats {
    
    private let gpuStats: GPUStats
    private let cpuStats: CPUStats
    
    public init(
        gpuStats: GPUStats = GPUStats(),
        cpuStats: CPUStats = CPUStats()
    ) {
        self.gpuStats = gpuStats
        self.cpuStats = cpuStats
    }
    
    public func getGPUStats() -> GPUInfo {
        gpuStats.getGPUInfo()
    }
    
    public func getCPUStats() -> CPUInfo {
        cpuStats.getCPUUsage()
    }
}

