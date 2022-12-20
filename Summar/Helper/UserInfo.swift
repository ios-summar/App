import Foundation
import Alamofire

// https://nsios.tistory.com/21
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
        case socialType = "social_Type"
        case follower = "follower"
        case following = "following"
        case introduce = "introduce"
    }
    
    init(userEmail: String?, userNickname: String?, major1: String?, major2: String?, socialType: String?, follower: Int?, following: Int?, introduce: String?) {
        self.userEmail = userEmail
        self.userNickname = userNickname
        self.major1 = major1
        self.major2 = major2
        self.socialType = socialType
        self.follower = follower
        self.following = following
        self.introduce = introduce
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
