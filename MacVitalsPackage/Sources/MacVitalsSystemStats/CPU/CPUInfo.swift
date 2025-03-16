import MacVitalsConstants

public struct CPUInfo {
    public let usagePercentage: String
    
    public init(usagePercentage: String = Constants.Strings.unknown) {
        self.usagePercentage = usagePercentage
    }
}
