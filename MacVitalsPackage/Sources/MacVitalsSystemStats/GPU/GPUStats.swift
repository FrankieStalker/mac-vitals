import Metal
import IOKit

private enum GPUInfoType {
    case ioKit
    case metal
}

public struct GPUStats {
    
    let metalProvider: MetalProvider
    let iokitProvider: IOKitProvider
    
    public init(
        metalProvider: MetalProvider = DefaultMetalProvider(),
        iokitProvider: IOKitProvider = DefaultIOKitProvider()
    ) {
        self.metalProvider = metalProvider
        self.iokitProvider = iokitProvider
    }
    
    public func getGPUInfo() -> GPUInfo {
        var gpuInfo = GPUInfo()
        
        gpuInfo = getGPUInfo(with: gpuInfo, from: .metal)
        gpuInfo = getGPUInfo(with: gpuInfo, from: .ioKit)
    
        return gpuInfo
    }
    
    private func getGPUInfo(with gpuInfo: GPUInfo, from gpuStatsType: GPUInfoType) -> GPUInfo {
        switch gpuStatsType {
        case .metal:
            metalInfo(with: gpuInfo)
            
        case .ioKit:
            ioKitInfo(with: gpuInfo)
        }
    }
}

private extension GPUStats {
    private func metalInfo(with gpuInfo: GPUInfo) -> GPUInfo {
        GPUInfo(
            gpuName: metalProvider.getDeviceName() ?? gpuInfo.gpuName,
            gpuMemory: metalProvider.getDeviceMemory() ?? gpuInfo.gpuMemory
        )
    }
    
    private func ioKitInfo(with gpuInfo: GPUInfo) -> GPUInfo {
        let utilization = iokitProvider.getGPUUtilization() ?? gpuInfo.gpuUtilisation
        
        return GPUInfo(
            gpuName: gpuInfo.gpuName,
            gpuMemory: gpuInfo.gpuMemory,
            gpuUtilisation: utilization
        )
    }
}
