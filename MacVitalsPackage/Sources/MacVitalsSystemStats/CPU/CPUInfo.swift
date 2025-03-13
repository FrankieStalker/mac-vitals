public struct CPUInfo {
    public let usagePercentage: String
    
    public init(usagePercentage: String = "Unknown") {
        self.usagePercentage = usagePercentage
    }
}
