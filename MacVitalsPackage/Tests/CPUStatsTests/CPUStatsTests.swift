import Testing

import IOKit

@testable import MacVitalsSystemStats

struct CPUStatsTests {

    @Test func whenGettingCPUUsage_thenReturnCPUUsage() {
        let mock = MockCPUInfoProvider()
        mock.mockPointer = mock.mockCPUInfo.withUnsafeMutableBufferPointer {
            UnsafeMutablePointer(mutating: $0.baseAddress)
        }
        mock.result = KERN_SUCCESS
        
        let sut = CPUStats(cpuInfoProvider: mock)
        
        let cpuInfo = sut.getCPUUsage()
        
        #expect(mock.hasDeallocated == true)
        #expect(mock.result == KERN_SUCCESS)
        #expect(mock.mockPointer != nil)
        #expect(!cpuInfo.usagePercentage.isEmpty)
    }
    
    @Test func givenNilCPUInfo_whenGettingCPUUsage_thenReturnUnknownCPUUsage() {
        let mock = MockCPUInfoProvider()
        mock.result = KERN_SUCCESS
        
        let sut = CPUStats(cpuInfoProvider: mock)
        
        let cpuInfo = sut.getCPUUsage()
        
        #expect(mock.hasDeallocated == false)
        #expect(mock.result == KERN_SUCCESS)
        #expect(mock.mockPointer == nil)
        #expect(cpuInfo.usagePercentage == "Unknown")
    }
    
}

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
