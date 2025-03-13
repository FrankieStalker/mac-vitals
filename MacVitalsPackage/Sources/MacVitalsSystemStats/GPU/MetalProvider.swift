import Metal

public protocol MetalProvider {
    func getDeviceName() -> String?
    func getDeviceMemory() -> String?
}

public struct DefaultMetalProvider: MetalProvider {
    
    public init() {}
    
    public func getDeviceName() -> String? {
        MTLCreateSystemDefaultDevice()?.name
    }
    
    public func getDeviceMemory() -> String? {
        if let device = MTLCreateSystemDefaultDevice() {
            let memory = Double(device.recommendedMaxWorkingSetSize) / (1024 * 1024 * 1024)
            return String(format: "%.2f GB", memory)
        }
        return nil
    }
}
