import MacVitalsConstants

public struct RAMInfo: Equatable {
    public var totalRam: String
    public var usedRam: String
    public var freeRam: String
    public var wiredRam: String
    public var compressedRam: String
    public var cachedRam: String
    public var swapUsedRam: String
    
    public init(
        totalRam: String = Constants.Strings.unknown,
        usedRam: String = Constants.Strings.unknown,
        freeRam: String = Constants.Strings.unknown,
        wiredRam: String = Constants.Strings.unknown,
        compressedRam: String = Constants.Strings.unknown,
        cachedRam: String = Constants.Strings.unknown,
        swapUsedRam: String = Constants.Strings.unknown
    ) {
        self.totalRam = totalRam
        self.usedRam = usedRam
        self.freeRam = freeRam
        self.wiredRam = wiredRam
        self.compressedRam = compressedRam
        self.cachedRam = cachedRam
        self.swapUsedRam = swapUsedRam
    }
}
