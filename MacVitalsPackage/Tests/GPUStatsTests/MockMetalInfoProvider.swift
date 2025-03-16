import MacVitalsSystemStats

struct MockMetalInfoProvider: MetalProvider {
    var deviceName: String?
    var deviceMemory: String?
    
    func getDeviceName() -> String? {
        deviceName
    }
    
    func getDeviceMemory() -> String? {
        deviceMemory
    }
}
