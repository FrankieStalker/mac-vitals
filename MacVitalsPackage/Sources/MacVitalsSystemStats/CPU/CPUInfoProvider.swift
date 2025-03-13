import IOKit

public protocol CPUInfoProvider {
    func getNumCPUs() -> Int
    func getCPUInfo(size: inout mach_msg_type_number_t) -> CPUInfoResult
    func deallocate(cpuInfo: processor_info_array_t, sizeInBytes: vm_size_t)
}

public struct DefaultCPUInfoProvider: CPUInfoProvider {
    
    public init() {}
    
    public func getNumCPUs() -> Int {
        var numCPUs: natural_t = 0
        let mibKeys: [Int32] = [CTL_HW, HW_NCPU]
        
        mibKeys.withUnsafeBufferPointer { mib in
            var size = MemoryLayout<natural_t>.size
            sysctl(UnsafeMutablePointer(mutating: mib.baseAddress), 2, &numCPUs, &size, nil, 0)
        }
        
        return Int(numCPUs)
    }
    
    public func getCPUInfo(size: inout mach_msg_type_number_t) -> CPUInfoResult {
        var inputSize = size
        var cpuInfo: processor_info_array_t?
        
        let result = host_processor_info(
            mach_host_self(),
            PROCESSOR_CPU_LOAD_INFO,
            &inputSize,
            &cpuInfo,
            &size
        )
        
        return CPUInfoResult(result: result, cpuInfo: cpuInfo)
    }
    
    public func deallocate(cpuInfo: processor_info_array_t, sizeInBytes: vm_size_t) {
        vm_deallocate(
            mach_host_self(),
            vm_address_t(bitPattern: cpuInfo),
            sizeInBytes
        )
    }
}

public struct CPUInfoResult {
    public let result: kern_return_t
    public let cpuInfo: processor_info_array_t?
    
    public init(result: kern_return_t, cpuInfo: processor_info_array_t?) {
        self.result = result
        self.cpuInfo = cpuInfo
    }
}
