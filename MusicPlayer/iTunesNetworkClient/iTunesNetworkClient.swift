
public class iTunesNetworkClient: NetworkClientable {
    public static var scheme: String {
        return "https"
    }
    
    public static var host: String {
        return "itunes.apple.com"
    }

    public static var path: String {
        return ""
    }
    
    public enum Method: Int, Methodable {
        case search
        
        public var number: Int {
            return rawValue
        }
        
        public var serverInfo: ServerInfo.Type {
            return iTunesNetworkClient.self
        }
        
        public var name: String? {
            switch self {
            case .search: return "search"
            }
        }
        
        public var headerValues: HeaderValues? {
            return [
                HTTPHeaderField.contentType: HTTPHeaderValue.applicationJson
            ]
        }
    }
}

