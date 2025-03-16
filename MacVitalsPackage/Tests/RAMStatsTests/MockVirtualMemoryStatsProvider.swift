import Foundation

import MacVitalsSystemStats

class MockVirtualMemoryStatsProvider: VirtualMemoryStatsProvider {
    var pageSize: vm_size_t = 1
    var result: Int32 = 1
    var stats = vm_statistics64()
    
    func returnVMStats() -> VirtualMemoryStats {
        return VirtualMemoryStats(stats: stats, pageSize: pageSize, result: result)
    }
}
