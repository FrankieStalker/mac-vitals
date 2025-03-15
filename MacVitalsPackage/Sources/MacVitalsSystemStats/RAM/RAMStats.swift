import Foundation
import IOKit

import MacVitalsConstants

public struct RAMStats {
    
    let virtualMemoryStatsProvider: VirtualMemoryStatsProvider
    
    public init(virtualMemoryStatsProvider: VirtualMemoryStatsProvider = DefaultVirtualMemoryStatsProvider()) {
        self.virtualMemoryStatsProvider = virtualMemoryStatsProvider
    }
    
    public func getRAMInfo() -> RAMInfo {
        let vmStats = virtualMemoryStatsProvider.returnVMStats()

        return RAMInfo(
            totalRam: getTotalRAM(),
            usedRam: getUsedRAM(with: vmStats),
            freeRam: getFreeRAM(with: vmStats),
            wiredRam: getWiredRAM(with: vmStats),
            compressedRam: getCompressedRAM(with: vmStats),
            cachedRam: getCachedRAM(with: vmStats),
            swapUsedRam: getSwapUsedRAM(with: vmStats)
        )
    }
    
    private func getTotalRAM() -> String {
        let stats = ProcessInfo.processInfo.physicalMemory
        let memory = Double(stats) / Constants.Numbers.conversionToGB
        return String(format: Constants.Strings.toTwoDecimals, memory)
    }
    
    private func getUsedRAM(with vmStats: VirtualMemoryStats) -> String {
        if vmStats.result != KERN_SUCCESS {
            return Constants.Strings.unknown
        }
        let appMemory = Double(vmStats.stats.active_count) * Double(vmStats.pageSize)
        let wiredMemory = Double(vmStats.stats.wire_count) * Double(vmStats.pageSize)
        let compressedMemory = Double(vmStats.stats.compressor_page_count) * Double(vmStats.pageSize)
        let totalUsedMemory = (appMemory + wiredMemory + compressedMemory) / Constants.Numbers.conversionToGB
        
        return String(format: Constants.Strings.toTwoDecimals, totalUsedMemory)
    }
    
    private func getFreeRAM(with vmStats: VirtualMemoryStats) -> String {
        if vmStats.result != KERN_SUCCESS {
            return Constants.Strings.unknown
        }
        
        let freeMemory = Double(vmStats.stats.free_count + vmStats.stats.inactive_count) * Double(vmStats.pageSize) / Constants.Numbers.conversionToGB
        
        return String(format: Constants.Strings.toTwoDecimals, freeMemory)
    }
    
    private func getWiredRAM(with vmStats: VirtualMemoryStats) -> String {
        if vmStats.result != KERN_SUCCESS {
            return Constants.Strings.unknown
        }
        
        let wiredRam = Double(vmStats.stats.wire_count) * Double(vmStats.pageSize) / Constants.Numbers.conversionToGB
        
        return String(format: Constants.Strings.toTwoDecimals, wiredRam)
    }
    
    private func getCompressedRAM(with vmStats: VirtualMemoryStats) -> String {
        if vmStats.result != KERN_SUCCESS {
            return Constants.Strings.unknown
        }
        
        let compressedRam = Double(vmStats.stats.compressor_page_count) * Double(vmStats.pageSize) / Constants.Numbers.conversionToGB
        
        return String(format: Constants.Strings.toTwoDecimals, compressedRam)
    }
    
    private func getCachedRAM(with vmStats: VirtualMemoryStats) -> String {
        if vmStats.result != KERN_SUCCESS {
            return Constants.Strings.unknown
        }
        
        let cachedRam = Double(vmStats.stats.inactive_count) * Double(vmStats.pageSize) / Constants.Numbers.conversionToGB
        
        return String(format: Constants.Strings.toTwoDecimals, cachedRam)
    }
    
    private func getSwapUsedRAM(with vmStats: VirtualMemoryStats) -> String {
        if vmStats.result != KERN_SUCCESS {
            return Constants.Strings.unknown
        }
        
        let swapUsed = (Double(vmStats.stats.swapins) + Double(vmStats.stats.swapouts)) * Double(vmStats.pageSize) / Constants.Numbers.conversionToGB
        
        return String(format: Constants.Strings.toTwoDecimals, swapUsed)
    }
}

public protocol VirtualMemoryStatsProvider {
    func returnVMStats() -> VirtualMemoryStats
}

public struct DefaultVirtualMemoryStatsProvider: VirtualMemoryStatsProvider {
    
    public init() {}
    
    public func returnVMStats() -> VirtualMemoryStats {
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: stats) / MemoryLayout<integer_t>.size)
        
        var pageSize: vm_size_t = 0
        host_page_size(mach_host_self(), &pageSize)
        
        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        
        return VirtualMemoryStats(stats: stats, pageSize: pageSize, result: result)
    }
}
