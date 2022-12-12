//
//  KakaoLoginManager.swift
//  Summar
//
//  Created by mac on 2022/11/07.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

protocol SocialSuccessDelegate : AnyObject {
    func pushIdentifier(_ VC: UIViewController,_ requestDic: Dictionary<String, String>)
}

class KakaoLoginManager : NSObject, ServerDelegate {
    
    weak var delegate : SocialSuccessDelegate?
    
    let helper = Helper()
    let request = ServerRequest()
    
    let socialType = "KAKAO"
    var requestDic : Dictionary<String, String> = Dictionary<String, String>()
    
    override init() {
        super.init()
        request.delegate = self
    }
    
    func kakaoLogin() {
            if (UserApi.isKakaoTalkLoginAvailable()) { // 카카오톡 어플이 있을 때
                DispatchQueue.global().sync {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        if let error = error {
                            print(error)
                        }else {
                            self.getUserInfo()
                        }
                    }
                }
            } else { // 카카오톡 어플이 없을 때
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }else {
                        self.getUserInfo()
                    }
                }
            }
    }
    
    // MARK : - 해당 함수에서 회원인지 확인
    func getUserInfo() {
        UserApi.shared.me { User, Error in
            if let id = User?.id {
                print("id => ", id)
                self.requestDic["userEmail"] = String(id)
                self.requestDic["userNickname"] = ""
                self.requestDic["major1"] = ""
                self.requestDic["major2"] = ""
                self.requestDic["socialType"] = self.socialType
                
                self.request.login("/user/login", self.requestDic) // 이후 memberYN으로 화면이동
            }else {
                print(Error)
            }
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
