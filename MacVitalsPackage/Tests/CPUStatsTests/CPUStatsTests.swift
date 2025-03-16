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
