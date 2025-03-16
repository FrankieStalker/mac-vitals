import MacVitalsConstants

public struct GPUInfo {
    public let gpuName: String
    public let gpuMemory: String
    public let gpuUtilisation: String
    
    public init(
        gpuName: String = Constants.Strings.unknown,
        gpuMemory: String = Constants.Strings.unknown,
        gpuUtilisation: String = Constants.Strings.unknown
    ) {
        self.gpuName = gpuName
        self.gpuMemory = gpuMemory
        self.gpuUtilisation = gpuUtilisation
    }
}
