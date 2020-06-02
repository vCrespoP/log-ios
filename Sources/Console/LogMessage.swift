import Foundation

public struct LogMessage {
    // MARK: Properties
    
    var emoji: String?
    var date: Date
    var message: String
    var level: LogLevel
    var filename: String
    var line: Int
    var column: Int
    var funcName: String
    
    private static var dateFormat = "dd/MM/yyyy hh:mm:ss"
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
}

// MARK: Public methods

extension LogMessage {
    var formattedString: String {
        let components: [String] = [
            self.emoji,
            " ",
            self.format(date: Date()),
            " [",
            self.sourceFileName(filePath: self.filename),
            ": ",
            "\(self.line)",
            "] ",
            //            "\(column)",
            //            " ",
            // self.funcName,
            self.message
        ]
        .compactMap { $0 }
        
        let result = components.joined(separator: "")
        
        return result
    }
}

// MARK: Private methods

private extension LogMessage {
    func format(date: Date) -> String {
        return type(of: self).dateFormatter.string(from: date)
    }
    
    func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        guard let lastComponent = components.last else {
            return ""
        }
        return lastComponent
    }
}
