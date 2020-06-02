import Foundation

public enum LogLevel: Int {
    case verbose = 1
    case debug
    case info
    case warning
    case error
    case critical
    case none
}

extension LogLevel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}
