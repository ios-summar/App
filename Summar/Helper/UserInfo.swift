import Foundation
import Alamofire

struct UserInfo: Codable {
    let userEmail: String?
    let userNickname: String?
    let major1: String?
    let major2: String?
    let socialType: String?
    let follower: Int?
    let following: Int?
    let introduce: String?
    
    enum CodingKeys: String, CodingKey {
        case userEmail = "userEmail"
        case userNickname = "userNickname"
        case major1 = "major1"
        case major2 = "major2"
        case socialType = "socialType"
        case follower = "follower"
        case following = "following"
        case introduce = "introduce"
    }
}

// MARK: Convenience initializers
extension UserInfo {
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(UserInfo.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//// MARK: - Alamofire response handlers
//extension DataRequest {
//    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer {
//        return DataResponseSerializer { _, response, data, error in
//            guard error == nil else { return .failure(error!) }
//
//            guard let data = data else {
//                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
//            }
//
//            return Result { try JSONDecoder().decode(T.self, from: data) }
//        }
//    }
//
//    @discardableResult
//    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
//        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
//    }
//
//    @discardableResult
//    func responsePhoto(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<UserInfo>) -> Void) -> Self {
//        return responseDecodable(queue: queue, completionHandler: completionHandler)
//    }
//}
