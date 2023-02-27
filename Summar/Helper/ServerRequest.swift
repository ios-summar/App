//
//  ServerRequest.swift
//  Summar
//
//  Created by mac on 2022/11/01.
//

import Foundation
import Alamofire


// MARK: - Summar 서버 URL
struct Server {
    static var url: String {
        let url = Bundle.main.url(forResource: "Network", withExtension: "plist")
        let dictionary = NSDictionary(contentsOf: url!)
        let LocalURL = dictionary!["ReleaseURL"] as? String
        
        return LocalURL!
    }
}

final class ServerRequest: NSObject {
    static let shared = ServerRequest()
    
    var param : Dictionary<String, Any> = Dictionary<String, Any>()
    var requestParam : Dictionary<String, String> = Dictionary<String, String>()
    
    func requestGet(_ url: String) {
        let url = "http://13.209.114.45:8080/api/v1\(url)"
        AF.request(url,
                   method: .post,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .validate(statusCode: 200..<300)
        .responseJSON { (json) in
            //여기서 가져온 데이터를 자유롭게 활용하세요.
            print(json)
        }
    }
    
    func nicknameCheck(requestUrl : String!, completion: @escaping (Bool?, Error?) -> ()) {
        let url = Server.url + requestUrl
        AF.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("nicknameCheck return value \(value)")
                guard let result = response.data else {return}
                                
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(NicknameCheck.self, from: result)
                    completion(json.result?.result, nil)
                    
                } catch {
                    print("error! \(error)")
                    completion(nil, error)
                }
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    // MARK: - 로그인, 회원가입 func => 서버의 loginStatus 값으로 회원인지, 회원이 아닌지 확인후 화면 이동
    func login(_ url: String,_ requestDic: Dictionary<String, Any>, completion : @escaping(Bool? ,Dictionary<String, Any>) -> ()) {
        let url = Server.url + url
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        var params = requestDic
        params["deviceToken"] = UserDefaults.standard.string(forKey: "deviceToken")
        
        print("/login params => \(params)")
        
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
                
                var json = value as! Dictionary<String, Any>
//                print(json["accessToken"])
                print(json["loginStatus"])
//                print(json["refreshToken"])
                json["userEmail"] = params["userEmail"]
                json["socialType"] = params["socialType"]
                
                params["loginStatus"] = json["loginStatus"]
                
                let loginStatus = json["loginStatus"] as! String
                
                
                if loginStatus == "로그인"{
                    //UserDefault에 회원정보 저장
                    print("params => \(params)")
                    
                    UserDefaults.standard.set(json, forKey: "UserInfo")
                    UserDefaults.standard.set(json["accessToken"], forKey: "accessToken")
                    UserDefaults.standard.set(json["refreshToken"], forKey: "refreshToken")
                    
                    UserDefaults.standard.synchronize()
                    
                    completion(true, params)
                } else if loginStatus == "회원가입"{
                    completion(false, params)
                } else if loginStatus == "회원가입완료"{
                    print(#line ,type(of: params["userEmail"]))
                    print("params => \(params)")
                    
                    params["follower"] = 0
                    params["following"] = 0
                    params["userSeq"] = json["userSeq"]
                    UserDefaults.standard.set(params, forKey: "UserInfo")
                    UserDefaults.standard.set(json["accessToken"], forKey: "accessToken")
                    UserDefaults.standard.set(json["refreshToken"], forKey: "refreshToken")
                    
                    UserDefaults.standard.synchronize()
                    
                    completion(true, params)
                }
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    // MARK: - 마이 써머리 유저 프로필 https://github.com/arifinfrds/iOS-MVVM-Alamofire
    func requestMyInfo(_ url: String, completion: @escaping (UserInfo?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(UserInfo.self, from: result)
                        
                        completion(json, nil, nil)
                        
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 신고하기
    /// 신고하기
    func report(_ url: String, _ param: Dictionary<String, Any>, completion: @escaping (Bool?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .post,
                       parameters: param,
                       encoding: JSONEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(NicknameCheck.self, from: result)
                        
                        
                        completion(json.result?.result, nil, nil)
                        
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 타 회원들 팔로우 여부 확인
    ///타 회원들 팔로우 여부 확인
    func followCheck(_ url: String, completion: @escaping (Bool?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(NicknameCheck.self, from: result) // 파싱 구조가 같아서 사용
                        
                        completion(json.result?.result, nil, nil)
                        
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 타 회원들 팔로우 / 팔로우 취소
    ///타 회원들 팔로우 여부 확인
    func followAction(_ url: String, _ param: Dictionary<String, Int> , _ httpMethod: String, completion: @escaping (ServerResult?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: HTTPMethod(rawValue: "\(httpMethod)"),
                       parameters: param,
                       encoding: JSONEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(ServerResult.self, from: result) // 파싱 구조가 같아서 사용
                        
                        completion(json, nil, nil)
                        
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    /// 팔로워, 팔로잉 전체리스트
    func followList(_ url: String, completion: @escaping (SearchUserList?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(SearchUserList.self, from: result)
                        
                        completion(json, nil, nil)
                        
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 마이 써머리 유저 피드, 임시저장
    func requestMyFeed(_ url: String, completion: @escaping (FeedSelectResponse?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(FeedSelectResponse.self, from: result)
                        
                        completion(json, nil, nil)
                        
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 회원탈퇴
    func requestWithDraw(_ url: String, completion: @escaping (ServerResult?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .delete,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(ServerResult.self, from: result)
                        
                        completion(json, nil, nil)
                        
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - UITabBar 닉네임 검색
    func searchNickname(_ url: String, completion: @escaping (SearchUserList?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json; charset=utf-8", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                    
                    print("value => \(value)")
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(SearchUserList.self, from: result)

                        completion(json, nil, nil)

                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 환경설정, 푸시알림 DB SELECT
    func getPushYN(_ url: String, completion: @escaping (PushInfo?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    smLog("")
                    print(value)
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(PushInfo.self, from: result)
                        
                        completion(json, nil, nil)
                        
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 환경설정, 푸시알림 DB Update
    func changePushYN(_ url: String,_ param: Dictionary<String, Any>, completion: @escaping (String?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .post,
                       parameters: param,
                       encoding: JSONEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    smLog("")
                    print(value)
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(ServerResult.self, from: result)
                        
                        completion(json.status, nil, nil)
                        
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
//    /api/v1/setting?status=notice => 공지사항 관련 정보
//    /api/v1/setting?status=question=> 자주 묻는 질문 관련정보
    
    // MARK: - 환경설정, 공지사항 DB Select /setting?status=notice
    func notice(_ url: String, completion: @escaping (Notice?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(Notice.self, from: result)
                        
                        completion(json, nil, nil)
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 회원정보수정
    func updateUserInfo(_ url: String ,_ param: Dictionary<String, Any> ,completion: @escaping (ServerResult?, Error?, Int?) -> ()) {
        let photo = param["profileImageUrl"] as? UIImage
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.upload(multipartFormData: { (multipart) in
                if let photo = photo {
                    if let imageData = photo.jpegData(compressionQuality: 1) {
                        multipart.append((imageData), withName: "file", fileName: "\(param["profileImageUrl"]).jpg", mimeType: "image/jpeg")
                        //이미지 데이터를 put할 데이터에 덧붙임
                    }
                }
                
                for (key, value) in param {
                  multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                  //이미지 데이터 외에 같이 전달할 데이터
              }
            }, to: url,
           method: .put,
           headers: ["Content-Type":"multipart/form-data", "Accept":"application/json",
                     "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                    print("value => \(value)")
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(ServerResult.self, from: response.data!)

                        completion(json, nil, nil)

                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 피드등록
    func insertFeed(_ url: String, _ param : Dictionary<String, Any>, _ imageArr: [UIImage], completion: @escaping (FeedInsertResponse?, Error?, Int?) -> ()) {
                
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.upload(multipartFormData: { (multipart) in
                for x in 0 ..< imageArr.count {
                    if let imageData = imageArr[x].jpegData(compressionQuality: 1) {
                        multipart.append(imageData, withName: "images", fileName: "\(param["profileImageUrl"]).jpg", mimeType: "image/jpeg")
                        //이미지 데이터를 put할 데이터에 덧붙임
                    }
                }
                
                for (key, value) in param {
                  multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                  //이미지 데이터 외에 같이 전달할 데이터
              }
            }, to: url,
           method: .post,
           headers: ["Content-Type":"multipart/form-data", "Accept":"application/json",
                     "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    guard let result = response.data else {return}
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(FeedInsertResponse.self, from: response.data!)

                        completion(json, nil, nil)

                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 피드수정
    func updateFeed(_ url: String, _ param : Dictionary<String, Any>, _ imageArr: [UIImage], completion: @escaping (FeedInsertResponse?, Error?, Int?) -> ()) {
                
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.upload(multipartFormData: { (multipart) in
                for x in 0 ..< imageArr.count {
                    if let imageData = imageArr[x].jpegData(compressionQuality: 1) {
                        multipart.append(imageData, withName: "images", fileName: "\(param["profileImageUrl"]).jpg", mimeType: "image/jpeg")
                        //이미지 데이터를 put할 데이터에 덧붙임
                    }
                }
                
                for (key, value) in param {
                  multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                  //이미지 데이터 외에 같이 전달할 데이터
              }
            }, to: url,
           method: .put,
           headers: ["Content-Type":"multipart/form-data", "Accept":"application/json",
                     "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    guard let result = response.data else {return}
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(FeedInsertResponse.self, from: response.data!)

                        completion(json, nil, nil)

                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 피드조회
    func selectFeed(_ url: String, completion: @escaping (FeedSelectResponse?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(FeedSelectResponse.self, from: result)
                        
                        completion(json, nil, nil)
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 스크랩 피드조회
    func scrapFeed(_ url: String, completion: @escaping (FeedSelectResponse?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(FeedSelectResponse.self, from: result)
                        
                        completion(json, nil, nil)
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 좋아요 / 스크랩
    /// 좋아요 / 스크랩
    func feedLikeScarp(_ url: String, _ param: Dictionary<String,Int>,completion: @escaping (NicknameCheck?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .post,
                       parameters: param,
                       encoding: JSONEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(NicknameCheck.self, from: result) // 형식이 같아 사용
                        
                        completion(json, nil, nil)
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 알림리스트
    /// 알림리스트
    func notificationList(_ url: String, completion: @escaping (NotificationModel?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(NotificationModel.self, from: result)
                        
                        completion(json, nil, nil)
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 특정 피드조회(FeedDetail)
    ///특정 피드조회(FeedDetail)
    func feedInfo(_ url: String, completion: @escaping (FeedInfo?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                    struct Response : Codable {
                        let result : FeedInfo
                    }
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(Response.self, from: result)
                        
                        completion(json.result, nil, nil)
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 특정 피드삭제(FeedDelete)
    ///특정 피드삭제(FeedDelete)
    func deleteFeed(_ url: String, completion: @escaping (FeedInfo?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .patch,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                    struct Response : Codable {
                        let result : FeedInfo
                    }
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(Response.self, from: result)
                        
                        completion(json.result, nil, nil)
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 특정 피드조회(FeedDetail)
    ///특정 피드조회(FeedDetail)
    func getFeedComment(_ url: String, completion: @escaping (FeedComment?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(FeedComment.self, from: result)
                        
                        completion(json, nil, nil)
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 댓글 달기
    /// 댓글 달기
    func commentRegister(_ url: String,_ param: Dictionary<String, Any> , completion: @escaping (ServerResult?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .post,
                       parameters: param,
                       encoding: JSONEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(ServerResult.self, from: result)
                        
                        completion(json, nil, nil)
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - 댓글 삭제
    /// 댓글 삭제
    func commentRemove(_ url: String, completion: @escaping (ServerResult?, Error?, Int?) -> ()) {
        let url = Server.url + url
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("url => \(url)")
            print(token)
            AF.request(url,
                       method: .patch,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json",
                                 "Authorization":"Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(ServerResult.self, from: result)
                        
                        completion(json, nil, nil)
                    } catch {
                        print("error! \(error)")
                        completion(nil, error, nil)
                    }
                case .failure(let error):
                    print("🚫 @@Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    
                    var statusCode = response.response?.statusCode
                    completion(nil, error, statusCode)
                }
            }
        }
    }
    
    // MARK: - AccessToken 재발급
    func requestAccessToken(_ url: String, completion: @escaping (AccessToken?, Error?) -> ()) {
        let url = Server.url + url
        print("url => \(url)")
        
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo") {
            param = value
        }
        
        requestParam["userEmail"] = param["userEmail"] as! String
        
        print("requestAccessToken requestParam => \(requestParam)")
        
            AF.request(url,
                       method: .post,
                       parameters: requestParam,
                       encoding: JSONEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    guard let result = response.data else {return}
                                    
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(AccessToken.self, from: response.data!)
                        completion(json, nil)
                        
                    } catch {
                        print("error! \(error)")
                    }
                case .failure(let error):
                    print("🚫 !!Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")

                    completion(nil, error)
                    var statusCode = response.response?.statusCode
                    print("requestAccessToken statusCode => \(statusCode)")
                }
            }
    }
    
    // MARK: - RefreshToken, AccessToken 재발급
    func requestRefreshToken(_ url: String, completion: @escaping (Token?, Error?) -> ()) {
        let url = Server.url + url
        print("url => \(url)")

        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo") {
            param = value
        }

        print(param)

        requestParam["userEmail"] = param["userEmail"] as! String

            AF.request(url,
                       method: .post,
                       parameters: requestParam,
                       encoding: JSONEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("value ==> \(value)")
                    guard let result = response.data else {return}

                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(Token.self, from: response.data!)
                        print("json => \(json)")

                        completion(json, nil)

                    } catch {
                        print("error! \(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    print("🚫 ##Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    completion(nil, error)
                }
            }
    }
    
    // MARK: - AccessToken 혹은 RefreshToken 재요청
    func reloadToken(_ statusCode: Int?){
        if let statusCode = statusCode {
            if statusCode == 401{
                // 토큰 재요청
                smLog("AccessToken 토큰 재요청 -> UserDefault Change -> 서버요청")
                
                self.requestAccessToken("/user/give-access-token", completion: {(accessToken, error) in
                    
                    if let error = error {
                        smLog("error \(error)")
                        
                        smLog("AccessToken AND RefreshToken 재요청 -> UserDefault Change -> 서버요청")
                        
                        self.requestRefreshToken("/user/give-both-token", completion: {(bothToken, error) in
                            if let error = error {
                                smLog("error \(error)")
                            }
                            if let bothToken = bothToken {
                                smLog("bothToken \(bothToken)")
                                let accessToken = bothToken.results.accessToken
                                
                                UserDefaults.standard.set(accessToken, forKey: "accessToken")
                            }
                        })
                    }
                    
                    if let accessToken = accessToken {
                        let accessToken = accessToken.accessToken
                        
                        UserDefaults.standard.set(accessToken, forKey: "accessToken")
                    }
                })
                
            }
        }
    }
}
