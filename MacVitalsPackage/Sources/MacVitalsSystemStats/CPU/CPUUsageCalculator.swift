import IOKit

public protocol CPUUsageCalculator {
    func calculateCPUUsage(numCPUs: Int, cpuInfo: processor_info_array_t) -> String
}

public struct DefaultCPUUsageCalculator: CPUUsageCalculator {
    
    public init() {}
    
    public func calculateCPUUsage(numCPUs: Int, cpuInfo: processor_info_array_t) -> String {
        var totalUsage: Double = 0
        let cpuStateMax = Int(CPU_STATE_MAX)
        
        for i in 0..<numCPUs {
            let baseIndex = cpuStateMax * i
            totalUsage += returnTotalUsage(with: cpuInfo, and: baseIndex)
        }

        if numCPUs > 0 {
            totalUsage /= Double(numCPUs)
        }
        
        return "\(Int(totalUsage * 100))%"
    }
    
    private func returnTotalUsage(with cpuInfo: processor_info_array_t, and baseIndex: Int) -> Double {
        let user = Double(cpuInfo[baseIndex + Int(CPU_STATE_USER)])
        let system = Double(cpuInfo[baseIndex + Int(CPU_STATE_SYSTEM)])
        let idle = Double(cpuInfo[baseIndex + Int(CPU_STATE_IDLE)])
        let nice = Double(cpuInfo[baseIndex + Int(CPU_STATE_NICE)])
        
        let total = user + system + idle + nice
        
        if total > 0 {
            return (user + system) / total
        }
        
        return 0
    }
}
