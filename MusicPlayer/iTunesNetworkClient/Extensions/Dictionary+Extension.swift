
extension Dictionary where Key: RawRepresentable, Key.RawValue == String, Value == Any {
    public var toJSONParam: JSONParam {
        var jsonParam: JSONParam = [:]
        
        for (key, value) in self {
            jsonParam[key.rawValue] = value
        }
        
        return jsonParam
    }
}
