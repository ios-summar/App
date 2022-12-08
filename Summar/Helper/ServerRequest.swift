//
//  ServerRequest.swift
//  Summar
//
//  Created by mac on 2022/11/01.
//

import Foundation
import Alamofire

protocol ServerDelegate : AnyObject {
    func memberYN(_ TF: Bool,_ requestDic: Dictionary<String, String>)
}

class ServerRequest: NSObject {
    weak var delegate : ServerDelegate?
    
    let serverURL = { () -> String in
        let url = Bundle.main.url(forResource: "Network", withExtension: "plist")
        let dictionary = NSDictionary(contentsOf: url!)
        
        // 각 데이터 형에 맞도록 캐스팅 해줍니다.
#if DEBUG
        var LocalURL = dictionary!["DebugURL"] as? String
#elseif RELEASE
        var LocalURL = dictionary!["ReleaseURL"] as? String
#endif
        
        return LocalURL!
    }
    
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
    
    // MARK : - 로그인, 회원가입 func => 서버의 loginStatus 값으로 회원인지, 회원이 아닌지 확인후 화면 이동
    func login(_ url: String,_ requestDic: Dictionary<String, String>){
        let responseBool : Bool? = nil
        let url = serverURL() + url
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        var params = requestDic
        
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                //                        let value = String(data: response.data!, encoding: .utf8)
                print(value)
                
                let json = value as! Dictionary<String, String>
                
                print(json["accessToken"])
                print(json["loginStatus"])
                print(json["refreshToken"])
                
                params["loginStatus"] = json["loginStatus"]
                
                let loginStatus = json["loginStatus"]
                
                
                if loginStatus == "로그인"{
                    //UserDefault에 회원정보 저장
                    print(#line ,type(of: params["userEmail"]))
                    
                    UserDefaults.standard.set(params["userEmail"], forKey: "userEmail")
//                    UserDefaults.standard.set(params["userNickName"], forKey: "userNickName")
//                    UserDefaults.standard.set(params["major1"], forKey: "major1")
//                    UserDefaults.standard.set(params["major2"], forKey: "major2")
                    UserDefaults.standard.set(params["socialType"], forKey: "socialType")
                    
                    self.delegate?.memberYN(true, params)
                } else if loginStatus == "회원가입"{
                    self.delegate?.memberYN(false, params)
                } else if loginStatus == "회원가입완료"{
                    print(#line ,type(of: params["userEmail"]))
                    
                    //UserDefault에 회원정보 저장
                    UserDefaults.standard.set(params["userEmail"], forKey: "userEmail")
                    UserDefaults.standard.set(params["userNickName"], forKey: "userNickName")
                    UserDefaults.standard.set(params["major1"], forKey: "major1")
                    UserDefaults.standard.set(params["major2"], forKey: "major2")
                    UserDefaults.standard.set(params["socialType"], forKey: "socialType")
                    
                    
                    
                    self.delegate?.memberYN(true, params)
                }
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
}
