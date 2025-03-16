import IOKit

public struct VirtualMemoryStats {
    public let stats: vm_statistics64
    public let pageSize: vm_size_t
    public let result: kern_return_t
    
    public init(
        stats: vm_statistics64,
        pageSize: vm_size_t,
        result: kern_return_t
    ) {
        self.stats = stats
        self.pageSize = pageSize
        self.result = result
    }
}
