
public func typename(_ any: Any) -> String {
    String(describing: type(of: any))
}
