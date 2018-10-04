
public class iTunesNetworkClientRequest: NetworkClientRequest {
    public typealias Param = [iTunesNetworkClient.Key: Any]
    
    public required init(httpMethod: HttpMethod, method: Methodable, param: Param, headerValues: HeaderValues) {
        super.init(httpMethod: httpMethod, method: method, param: param.toJSONParam, headerValues: headerValues)
    }
    
    public convenience required init(httpMethod: HttpMethod, method: Methodable, param: Param) {
        self.init(httpMethod: httpMethod, method: method, param: param, headerValues: [:])
    }
    
    public convenience required init(httpMethod: HttpMethod, method: Methodable) {
        self.init(httpMethod: httpMethod, method: method, param: [:], headerValues: [:])
    }
}
