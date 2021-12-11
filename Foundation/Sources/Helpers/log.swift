
public enum LogLevel: String {
    case `default` = ""
    case info = "🔹"
    case error = "🆘"
}

public func log(_ domain: String = "", level: LogLevel = .default, value: Any) {
    let domain = domain.isEmpty ? "" : "[\(domain)]\t\t "
    print("\(level.rawValue) \(domain)\(value)\n")
}
