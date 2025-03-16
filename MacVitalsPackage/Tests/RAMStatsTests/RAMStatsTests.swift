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
    
    @Test func givenRAMStats_whenFetchingInfo_thenTheFreeRamIsEqualToMockedRAMStats() {
        let mock = MockVirtualMemoryStatsProvider()
        mock.stats.free_count = 1_000_000
        mock.stats.inactive_count = 500_000
        mock.pageSize = 4096
        mock.result = KERN_SUCCESS
        
        let sut = RAMStats(virtualMemoryStatsProvider: mock)
        
        let result = sut.getRAMInfo()
        
        #expect(result.freeRam == RAMStatsTestHelpers.freeRam)
    }
    
    @Test func givenRAMStats_whenFetchingInfo_thenTheWiredRamIsEqualToMockedRAMStats() {
        let mock = MockVirtualMemoryStatsProvider()
        mock.stats.wire_count = 1_000_000
        mock.pageSize = 4096
        mock.result = KERN_SUCCESS
        
        let sut = RAMStats(virtualMemoryStatsProvider: mock)
        
        let result = sut.getRAMInfo()
        
        #expect(result.wiredRam == RAMStatsTestHelpers.wiredRam)
    }
    
    
    @Test func givenRAMStats_whenFetchingInfo_thenTheCompressedRamIsEqualToMockedRAMStats() {
        let mock = MockVirtualMemoryStatsProvider()
        mock.stats.compressor_page_count = 1_000_000
        mock.pageSize = 4096
        mock.result = KERN_SUCCESS
        
        let sut = RAMStats(virtualMemoryStatsProvider: mock)
        
        let result = sut.getRAMInfo()
        
        #expect(result.compressedRam == RAMStatsTestHelpers.compressedRam)
    }
    
    @Test func givenRAMStats_whenFetchingInfo_thenTheCachedRamIsEqualToMockedRAMStats() {
        let mock = MockVirtualMemoryStatsProvider()
        mock.stats.inactive_count = 1_000_000
        mock.pageSize = 4096
        mock.result = KERN_SUCCESS
        
        let sut = RAMStats(virtualMemoryStatsProvider: mock)
        
        let result = sut.getRAMInfo()
        
        #expect(result.cachedRam == RAMStatsTestHelpers.cachedRam)
    }
    
    @Test func givenRAMStats_whenFetchingInfo_thenTheSwapUsedRamIsEqualToMockedRAMStats() {
        let mock = MockVirtualMemoryStatsProvider()
        mock.stats.swapins = 1_000_000
        mock.stats.swapouts = 1_000_000
        mock.pageSize = 4096
        mock.result = KERN_SUCCESS
        
        let sut = RAMStats(virtualMemoryStatsProvider: mock)
        
        let result = sut.getRAMInfo()
        
        #expect(result.swapUsedRam == RAMStatsTestHelpers.swapUsedRam)
    }
}
