import Testing

@testable import MacVitalsSystemStats

struct GPUStatsTests {
    
    @Test func whenGettingMetalGPUInfo_thenReturnNameAndMemory() {
        let sut = GPUStats(metalProvider: MockMetalInfoProvider())
        
        let gpuInfo = sut.getGPUInfo()
        
        #expect(gpuInfo.gpuName == "Mock GPU")
        #expect(gpuInfo.gpuMemory == "12.00 GB")
    }
    
    @Test func whenGettingIOKitGPUInfo_thenReturnUtilization() {
        let sut = GPUStats(iokitProvider: MockIOKitProvider())
        
        let gpuInfo = sut.getGPUInfo()
        
        #expect(gpuInfo.gpuUtilisation == "50%")
    }
    
    @Test func whenGettingBothMetalAndIOKitGPUInfo_thenReturnNameAndMemoryAndUtilization() {
        let sut = GPUStats(metalProvider: MockMetalInfoProvider(), iokitProvider: MockIOKitProvider())
        
        let gpuInfo = sut.getGPUInfo()
        
        #expect(gpuInfo.gpuName == "Mock GPU")
        #expect(gpuInfo.gpuMemory == "12.00 GB")
        #expect(gpuInfo.gpuUtilisation == "50%")
    }
}

struct MockMetalInfoProvider: MetalProvider {
    func getDeviceName() -> String? {
        "Mock GPU"
    }
    
    func getDeviceMemory() -> String? {
        "12.00 GB"
    }
}

struct MockIOKitProvider: IOKitProvider {
    func getGPUUtilization() -> String? {
        "50%"
    }
}
