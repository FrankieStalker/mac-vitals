import Foundation

import MacVitalsConstants

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
    
    static var freeRam: String {
        let mock = MockVirtualMemoryStatsProvider()
        mock.stats.free_count = 1_000_000
        mock.stats.inactive_count = 500_000
        mock.pageSize = 4096
        mock.result = KERN_SUCCESS

        let freeMemory = Double(mock.stats.free_count + mock.stats.inactive_count) * Double(mock.pageSize) / Constants.Numbers.conversionToGB
        
        return String(format: Constants.Strings.toTwoDecimals, freeMemory)
    }
    
    static var wiredRam: String {
        let mock = MockVirtualMemoryStatsProvider()
        mock.stats.wire_count = 1_000_000
        mock.pageSize = 4096
        mock.result = KERN_SUCCESS
        
        let wiredRam = Double(mock.stats.wire_count) * Double(mock.pageSize) / Constants.Numbers.conversionToGB
        
        return String(format: Constants.Strings.toTwoDecimals, wiredRam)
    }
    
    static var compressedRam: String {
        let mock = MockVirtualMemoryStatsProvider()
        mock.stats.compressor_page_count = 1_000_000
        mock.pageSize = 4096
        mock.result = KERN_SUCCESS
        
        let wiredRam = Double(mock.stats.compressor_page_count) * Double(mock.pageSize) / Constants.Numbers.conversionToGB
        
        return String(format: Constants.Strings.toTwoDecimals, wiredRam)
    }
    
    static var cachedRam: String {
        let mock = MockVirtualMemoryStatsProvider()
        mock.stats.inactive_count = 1_000_000
        mock.pageSize = 4096
        mock.result = KERN_SUCCESS
        
        let cachedRam = Double(mock.stats.inactive_count) * Double(mock.pageSize) / Constants.Numbers.conversionToGB
        
        return String(format: Constants.Strings.toTwoDecimals, cachedRam)
    }
    
    static var swapUsedRam: String {
        let mock = MockVirtualMemoryStatsProvider()
        mock.stats.swapins = 1_000_000
        mock.stats.swapouts = 1_000_000
        mock.pageSize = 4096
        mock.result = KERN_SUCCESS
        
        let swapUsed = (Double(mock.stats.swapins) + Double(mock.stats.swapouts)) * Double(mock.pageSize) / Constants.Numbers.conversionToGB
        
        return String(format: Constants.Strings.toTwoDecimals, swapUsed)
    }
}
