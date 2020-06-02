import Foundation

/// Base implementation for Logger
open class BaseLogger {
    // MARK: - Properties
    
    internal let queue = DispatchQueue(label: "vCrespo.log")
    private var level: LogLevel
    public private(set) var history: CircularArray<LogMessage>
    
    // MARK: - Life Cycle
    
    public required init(level: LogLevel = .verbose, maxEntries: Int = 100) {
        self.level = level
        self.history = CircularArray(maxEntries: maxEntries)
    }
    
    // MARK: - Overrides
    
    open func print(message: String) {
        fatalError("Implement in specific Logger")
    }
}

extension BaseLogger: Logger {
    public func log(
        _ message: Any...,
        level: LogLevel,
        filename: String = #file,
        line: Int = #line,
        column: Int = #column,
        funcName: String = #function) {
        return self._log(message, level: .verbose, filename: filename, line: line, column: column, funcName: funcName)
    }
    
    // swiftlint:disable:next identifier_name
    public func _log(
        _ message: [Any],
        level: LogLevel,
        filename: String = #file,
        line: Int = #line,
        column: Int = #column,
        funcName: String = #function) {
        // Filter out log events by level
        guard level.rawValue >= self.level.rawValue else {
            return
        }
        
        let messagesJoined: String = self.format(message)
        
        let logMessage = LogMessage(
            emoji: level.emoji,
            date: Date(),
            message: messagesJoined,
            level: level,
            filename: filename,
            line: line,
            column: column,
            funcName: funcName)
        
        self.history.append(logMessage)
        
        let logMessageString = logMessage.formattedString
        self.print(message: logMessageString)
    }
    
    public func change(logLevel: LogLevel) {
        self.level = logLevel
    }
}

private extension BaseLogger {
    func format(_ messages: [Any]) -> String {
        let result = messages
            .map {
                return String(describing: $0)
            }
            .joined(separator: " ")
        return result
    }
}

private extension LogLevel {
    var emoji: String {
        switch self {
        case .verbose:
            return "🔳"
        case .debug:
            return "◽️"
        case .info:
            return "🔷"
        case .warning:
            return "🔶"
        case .error:
            return "🛑"
        case .critical:
            return "💥"
        case .none:
            return ""
        }
    }
}
