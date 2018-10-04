
public enum AppCellType: String, Identifierable {
    case song
    
    public var identifier: String {
        return rawValue
    }
}
