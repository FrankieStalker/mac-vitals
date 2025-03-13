public struct GPUInfo {
    public let gpuName: String
    public let gpuMemory: String
    public let gpuUtilisation: String
    
    public init(
        gpuName: String = "Unknown",
        gpuMemory: String = "Unknown",
        gpuUtilisation: String = "Unknown"
    ) {
        self.gpuName = gpuName
        self.gpuMemory = gpuMemory
        self.gpuUtilisation = gpuUtilisation
    }
}
