import Metal
import IOKit

public struct SystemStats {
    
    private let gpuStats: GPUStats
    
    public init(gpuStats: GPUStats = GPUStats()) {
        self.gpuStats = gpuStats
    }
    
    public func getGPUStats() -> GPUInfo {
        gpuStats.getGPUInfo()
    }
}

