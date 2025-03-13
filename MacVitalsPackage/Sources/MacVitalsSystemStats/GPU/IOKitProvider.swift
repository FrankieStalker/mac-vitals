import Foundation

import IOKit

public protocol IOKitProvider {
    func getGPUUtilization() -> String?
}

public struct DefaultIOKitProvider: IOKitProvider {
    
    public init() {}
    
    public func getGPUUtilization() -> String? {
        var iterator: io_iterator_t = 0
        guard isGPUMonitoringAvailable(&iterator) else { return nil }
        
        defer { IOObjectRelease(iterator) }
        
        return iterateIOKitServices(iterator) { service in
            var properties: Unmanaged<CFMutableDictionary>?
            if canReadRegistryProperties(service: service, properties: &properties) {
                let dict = properties!.takeRetainedValue() as NSDictionary
                if let util = dict["Device Utilization %"] as? Int {
                    return "\(util)%"
                }
            }
            return nil
        }
    }

    private func iterateIOKitServices(_ iterator: io_iterator_t, handler: (io_registry_entry_t) -> String?) -> String? {
        var service: io_registry_entry_t
        repeat {
            service = IOIteratorNext(iterator)
            if service == 0 { break }
            
            defer { IOObjectRelease(service) }
            
            if let result = handler(service) {
                return result
            }
        } while service != 0
        
        return nil
    }
    
    private func isGPUMonitoringAvailable(_ iterator: inout io_iterator_t) -> Bool {
        let matching = IOServiceMatching("IOAccelerator")
        return IOServiceGetMatchingServices(kIOMasterPortDefault, matching, &iterator) == KERN_SUCCESS
    }
    
    private func canReadRegistryProperties(
        service: io_registry_entry_t,
        properties: inout Unmanaged<CFMutableDictionary>?
    ) -> Bool {
        return IORegistryEntryCreateCFProperties(service, &properties, kCFAllocatorDefault, 0) == KERN_SUCCESS
    }
    
}
