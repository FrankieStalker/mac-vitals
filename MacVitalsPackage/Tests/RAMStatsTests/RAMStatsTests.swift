import Testing

import Foundation

@testable import MacVitalsSystemStats

import MacVitalsConstants

struct RAMStatsTests {
    
    @Test func givenRAMStats_whenFetchingInfo_thenTotalRamIsEqualToMaxMemory() {
        let sut = RAMStats()
        let result = sut.getRAMInfo()
        
        #expect(result.totalRam == RAMStatsTestHelpers.maxRam)
    }
    
    @Test func givenRAMStats_whenResultNotEqualToKERNSUCCESS_thenUnknownRAMInfo() {
        let mock = MockVirtualMemoryStatsProvider()
        let sut = RAMStats(virtualMemoryStatsProvider: mock)
        
        let unknownRamInfo = RAMInfo(totalRam: RAMStatsTestHelpers.maxRam)
        
        let result = sut.getRAMInfo()
        
        #expect(result == unknownRamInfo)
    }
    
    @Test func givenRAMStats_whenFetchingInfo_thenTheUsedRamIsEqualToMockedRAMStats() {
        let mock = MockVirtualMemoryStatsProvider()
        mock.stats.active_count = 1_000_000
        mock.stats.wire_count = 500_000
        mock.stats.compressor_page_count = 250_000
        mock.pageSize = 4096
        mock.result = KERN_SUCCESS
        
        let sut = RAMStats(virtualMemoryStatsProvider: mock)
        
        let result = sut.getRAMInfo()
        
        #expect(result.usedRam == RAMStatsTestHelpers.usedRam)
    }
}

enum RAMStatsTestHelpers {
    static var maxRam: String {
        String(
            format: Constants.Strings.toTwoDecimals,
            Double(ProcessInfo.processInfo.physicalMemory) / Constants.Numbers.conversionToGB
        )
    }
    
    static var usedRam: String {
        let mock = MockVirtualMemoryStatsProvider()
        mock.stats.active_count = 1_000_000
        mock.stats.wire_count = 500_000
        mock.stats.compressor_page_count = 250_000
        mock.pageSize = 4096
        mock.result = KERN_SUCCESS
        
        let appMemory = Double(mock.stats.active_count) * Double(mock.pageSize)
        let wiredMemory = Double(mock.stats.wire_count) * Double(mock.pageSize)
        let compressedMemory = Double(mock.stats.compressor_page_count) * Double(mock.pageSize)
        let totalUsedMemory = (appMemory + wiredMemory + compressedMemory) / Constants.Numbers.conversionToGB
        
        return String(format: Constants.Strings.toTwoDecimals, totalUsedMemory)
    }
}

class MockVirtualMemoryStatsProvider: VirtualMemoryStatsProvider {
    var pageSize: vm_size_t = 1
    var result: Int32 = 1
    var stats = vm_statistics64()
    
    func returnVMStats() -> VirtualMemoryStats {
        return VirtualMemoryStats(stats: stats, pageSize: pageSize, result: result)
    }
}
