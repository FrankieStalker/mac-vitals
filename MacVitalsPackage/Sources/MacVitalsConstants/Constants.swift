import math_h

public enum Constants {
    
    public enum Numbers {
        public static let conversionToGB = pow(.numberToCube, .three)
    }
    
    public enum Strings {
        public static let unknown = "Unknown"
        public static let toTwoDecimals = "%.2f GB"
    }
    
}

private extension Double {
    static let numberToCube: Double = 1024
    static let three: Double = 3
}
