
extension iTunesNetworkClient {
    public class func makeNewsAndOffersRequest(term: String, limit: Int, media: Media) -> iTunesNetworkClientRequest {
        let param: [Key: Any] = [
            .term: term.replacingOccurrences(of: " ", with: "+"),
            .limit: limit,
            .media: media.rawValue
        ]

        return iTunesNetworkClientRequest(httpMethod: .get, method: Method.search, param: param)
    }
    
    public enum Media: String {
        case music
    }
}
