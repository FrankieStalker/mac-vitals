import IOKit

import MacVitalsSystemStats

class MockCPUInfoProvider: CPUInfoProvider {
    
    var hasDeallocated = false
    var result: Int32?
    var mockPointer: UnsafeMutablePointer<Int32>?
    
    var mockCPUInfo: [Int32] = [
        100, 100, 100, 100, // First CPU
        100, 100, 100, 100  // Second CPU
    ]
    
    func getNumCPUs() -> Int {
        return mockCPUInfo.count
    }
    
    func getCPUInfo(size: inout mach_msg_type_number_t) -> CPUInfoResult {
        return CPUInfoResult(result: KERN_SUCCESS, cpuInfo: self.mockPointer)
    }
    
    func deallocate(cpuInfo: processor_info_array_t, sizeInBytes: vm_size_t) {
        hasDeallocated = true
    }
}
