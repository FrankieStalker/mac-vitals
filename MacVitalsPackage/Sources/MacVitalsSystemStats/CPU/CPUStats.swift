import IOKit

public struct CPUStats {
    private let cpuInfoProvider: CPUInfoProvider
    private let cpuUsageCalculator: CPUUsageCalculator
    
    public init(
        cpuInfoProvider: CPUInfoProvider = DefaultCPUInfoProvider(),
        cpuUsageCalculator:CPUUsageCalculator = DefaultCPUUsageCalculator()
    ) {
        self.cpuInfoProvider = cpuInfoProvider
        self.cpuUsageCalculator = cpuUsageCalculator
    }
    
    func getCPUUsage() -> CPUInfo {
        let numCPUs = cpuInfoProvider.getNumCPUs()
        var size = mach_msg_type_number_t(
            MemoryLayout<host_cpu_load_info_data_t>.stride / MemoryLayout<integer_t>.stride
        )

        let cpuInfoResult = cpuInfoProvider.getCPUInfo(size: &size)
        
        guard cpuInfoResult.result == KERN_SUCCESS, let cpuInfo = cpuInfoResult.cpuInfo else {
            return CPUInfo()
        }
        let sizeInBytes = vm_size_t(Int(size) * MemoryLayout<integer_t>.stride)
        
        defer { cpuInfoProvider.deallocate(cpuInfo: cpuInfo, sizeInBytes: sizeInBytes) }
        
        let usagePercentage = cpuUsageCalculator.calculateCPUUsage(
            numCPUs: numCPUs,
            cpuInfo: cpuInfo
        )
        return CPUInfo(usagePercentage: usagePercentage)
    }
}
