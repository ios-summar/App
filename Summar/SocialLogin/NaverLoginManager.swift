//
//  NaverLoginManager.swift
//  Summar
//
//  Created by mac on 2022/11/07.
//

import Foundation
import NaverThirdPartyLogin
import Alamofire

class NaverLoginManager: NSObject, ServerDelegate {
    
    weak var delegate: SocialSuccessDelegate?
    let request = ServerRequest()
    
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    let socialType = "NAVER"
    var requestDic : Dictionary<String, String> = Dictionary<String, String>()
    
    override init() {
        super.init()
        print("naver init()")
        naverLoginInstance?.requestDeleteToken()
        request.delegate = self
    }
    
    func naverLogin() {
        naverLoginInstance?.delegate = self
        naverLoginInstance?.requestThirdPartyLogin()
    }
}

extension NaverLoginManager: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print(#function)
        getNaverInfo()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print(#function)
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print(#function)
        naverLoginInstance?.requestDeleteToken()
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }
    
    private func getNaverInfo() {
        guard let isValidAccessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
          return
        }
        
        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            print(response.value!)
              guard let result = response.value as? [String: Any] else { return }
              guard let object = result["response"] as? [String: Any] else { return }
            
            print("result =>", result)
            
            print("result1 =>", result["message"])
            print("result2 =>", result["resultcode"])
            
            print("object =>", object)
            
            print(object["email"] ?? "")
            print(object["id"] ?? "")
            print(object["nickname"] ?? nil)
            print(object["profile_image"] ?? nil)
            
            let userIdentifier = object["id"] as? String
            
            self.requestDic["userEmail"] = userIdentifier
            self.requestDic["userNickName"] = ""
            self.requestDic["major1"] = ""
            self.requestDic["major2"] = ""
            self.requestDic["socialType"] = self.socialType
            
            self.request.login("/user/login", self.requestDic) // 이후 memberYN으로 화면이동
            
            
            }
      }
    
    func memberYN(_ TF: Bool,_ requestDic: Dictionary<String, String>) {
        print(#file , #function)
        if TF { // 로그인 화면으로
            self.delegate?.pushIdentifier(HomeController.shared, requestDic)
        }else { // 회원가입 화면으로
            self.delegate?.pushIdentifier(SignUpController.shared, requestDic)
        }
    }
}
