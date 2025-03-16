import Metal

import MacVitalsConstants

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
            let memory = Double(device.recommendedMaxWorkingSetSize) / Constants.Numbers.conversionToGB
            return String(format: Constants.Strings.toTwoDecimals, memory)
        }
        return nil
    }
}
