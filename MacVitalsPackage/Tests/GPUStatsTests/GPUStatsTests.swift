import Testing

@testable import MacVitalsSystemStats

struct GPUStatsTests {
    
    @Test func whenGettingMetalGPUInfo_thenReturnNameAndMemory() {
        var mock = MockMetalInfoProvider()
        mock.deviceName = .mockDeviceName
        mock.deviceMemory = .mockDeviceMemory
        
        let sut = GPUStats(metalProvider: mock)
        
        let gpuInfo = sut.getGPUInfo()
        
        #expect(gpuInfo.gpuName == .mockDeviceName)
        #expect(gpuInfo.gpuMemory == .mockDeviceMemory)
    }
    
    @Test func givenNilReturned_whenGettingMetalGPUInfo_thenReturnUnknown() {
        let mock = MockMetalInfoProvider()
        
        let sut = GPUStats(metalProvider: mock)
        
        let gpuInfo = sut.getGPUInfo()
        
        #expect(gpuInfo.gpuName == .mockNilValue)
        #expect(gpuInfo.gpuMemory == .mockNilValue)
    }
    
    @Test func givenNilReturned_whenGettingIOKitGPUInfo_thenReturnUtilization() {
        let mock = MockIOKitProvider()
        
        let sut = GPUStats(iokitProvider: mock)
        
        let gpuInfo = sut.getGPUInfo()
        
        #expect(gpuInfo.gpuUtilisation == .mockNilValue)
    }
    
    @Test func whenGettingIOKitGPUInfo_thenReturnUtilization() {
        var mock = MockIOKitProvider()
        mock.gpuUtilization = .mockGpuUtilization
        
        let sut = GPUStats(iokitProvider: mock)
        
        let gpuInfo = sut.getGPUInfo()
        
        #expect(gpuInfo.gpuUtilisation == .mockGpuUtilization)
    }
    
    @Test func whenGettingBothMetalAndIOKitGPUInfo_thenReturnNameAndMemoryAndUtilization() {
        var mockIOKit = MockIOKitProvider()
        mockIOKit.gpuUtilization = .mockGpuUtilization
        
        var mockMetal = MockMetalInfoProvider()
        mockMetal.deviceName = .mockDeviceName
        mockMetal.deviceMemory = .mockDeviceMemory
        
        let sut = GPUStats(metalProvider: mockMetal, iokitProvider: mockIOKit)
        
        let gpuInfo = sut.getGPUInfo()
        
        #expect(gpuInfo.gpuName == .mockDeviceName)
        #expect(gpuInfo.gpuMemory == .mockDeviceMemory)
        #expect(gpuInfo.gpuUtilisation == .mockGpuUtilization)
    }
}

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

struct MockIOKitProvider: IOKitProvider {
    var gpuUtilization: String?
    
    func getGPUUtilization() -> String? {
        gpuUtilization
    }
}


private extension String {
    static let mockDeviceName = "Mock GPU"
    static let mockDeviceMemory = "12.00 GB"
    static let mockGpuUtilization = "50%"
    static let mockNilValue = "Unknown"
}
