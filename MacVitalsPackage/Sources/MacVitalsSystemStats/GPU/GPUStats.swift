import Metal
import IOKit

private enum GPUInfoType {
    case ioKit
    case metal
}

public struct GPUStats {
    
    public init() {}
    
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

// MARK: - Metal funcs
private extension GPUStats {
    private func metalInfo(with gpuInfo: GPUInfo) -> GPUInfo {
        if let device = MTLCreateSystemDefaultDevice() {
            return GPUInfo(
                gpuName: device.name,
                gpuMemory: calculateGPUMemory(with: device)
            )
        }
        return gpuInfo
    }
    
    private func calculateGPUMemory(with device: any MTLDevice) -> String {
        let memory = Double(device.recommendedMaxWorkingSetSize) / (1024 * 1024 * 1024)
        return String(format: "%.2f GB", memory)
    }
}

// MARK: - IOKit funcs
private extension GPUStats {
    private func ioKitInfo(with gpuInfo: GPUInfo) -> GPUInfo {
        let utilization = fetchGPUUtilization() ?? gpuInfo.gpuUtilisation
        
        return GPUInfo(
            gpuName: gpuInfo.gpuName,
            gpuMemory: gpuInfo.gpuMemory,
            gpuUtilisation: utilization
        )
    }
    
    private func fetchGPUUtilization() -> String? {
        var iterator: io_iterator_t = 0
        guard isGPUMonitoringAvailable(&iterator) else { return nil }
        
        defer { IOObjectRelease(iterator) }
        
        return iterateIOKitServices(iterator) { service in
            var properties: Unmanaged<CFMutableDictionary>?
            if canReadRegistryProperties(service: service, properties: &properties) {
                let dict = properties!.takeRetainedValue() as NSDictionary
                if let util = dict["Device Utilization %"] as? Int {
                    return "\(util)%"
                }
            }
            return nil
        }
    }

    private func iterateIOKitServices(_ iterator: io_iterator_t, handler: (io_registry_entry_t) -> String?) -> String? {
        var service: io_registry_entry_t
        repeat {
            service = IOIteratorNext(iterator)
            if service == 0 { break }
            
            defer { IOObjectRelease(service) }
            
            if let result = handler(service) {
                return result
            }
        } while service != 0
        
        return nil
    }
    
    private func isGPUMonitoringAvailable(_ iterator: inout io_iterator_t) -> Bool {
        let matching = IOServiceMatching("IOAccelerator")
        return IOServiceGetMatchingServices(kIOMasterPortDefault, matching, &iterator) == KERN_SUCCESS
    }
    
    private func canReadRegistryProperties(
        service: io_registry_entry_t,
        properties: inout Unmanaged<CFMutableDictionary>?
    ) -> Bool {
        return IORegistryEntryCreateCFProperties(service, &properties, kCFAllocatorDefault, 0) == KERN_SUCCESS
    }
}
