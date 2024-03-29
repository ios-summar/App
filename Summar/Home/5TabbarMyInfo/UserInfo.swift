import Foundation
import Alamofire

// https://nsios.tistory.com/21
struct UserInfo: Codable {
    let result: Info
}

struct Info: Codable {
    let userSeq : Int?
    let userEmail: String?
    let userNickname: String?
    let major1: String?
    let major2: String?
    let socialType: String?
    let leaveYn: Bool?
    let follower: Int?
    let following: Int?
    let introduce: String?
    let profileImageUrl: String?
    let blocked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case userSeq = "userSeq"
        case userEmail = "userEmail"
        case userNickname = "userNickname"
        case major1 = "major1"
        case major2 = "major2"
        case socialType = "social_type"
        case follower = "follower"
        case leaveYn = "leaveYn"
        case following = "following"
        case introduce = "introduce"
        case profileImageUrl = "profileImageUrl"
        case blocked = "blocked"
    }
}

// MARK: Convenience initializers
extension Info {
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Info.self, from: data)
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
