import MacVitalsSystemStats

struct MockIOKitProvider: IOKitProvider {
    var gpuUtilization: String?
    
    func getGPUUtilization() -> String? {
        gpuUtilization
    }
}

