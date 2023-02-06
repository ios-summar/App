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
    func pushIdentifier(_ VC: UIViewController,_ requestDic: Dictionary<String, Any>)
}

final class KakaoLoginManager : NSObject{
    
    weak var delegate : SocialSuccessDelegate?
    
    let helper = Helper()
    let request = ServerRequest.shared
    
    let socialType = "KAKAO"
    var requestDic : Dictionary<String, String> = Dictionary<String, String>()
    
    override init() {
        super.init()
    }
    
    // MARK: - 카카오 로그인
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
    
    // MARK: - 해당 함수에서 회원인지 확인
    func getUserInfo() {
        UserApi.shared.me { User, Error in
            if let id = User?.id {
                print("id => ", id)
                self.requestDic["userEmail"] = String(id)
                self.requestDic["userNickname"] = ""
                self.requestDic["major1"] = ""
                self.requestDic["major2"] = ""
                self.requestDic["socialType"] = self.socialType
                
                self.request.login("/user/login", self.requestDic, completion: { (login, param) in
                    guard let login = login else {return}
                    self.memberYN(login, param)
                })
            }else {
                print(Error)
            }
        }
    }
    
    // MARK: - 화면이동 Delegate
    func memberYN(_ TF: Bool,_ requestDic: Dictionary<String, Any>) {
        if TF { // 로그인 화면으로
            self.delegate?.pushIdentifier(HomeController(), requestDic)
        }else { // 회원가입 화면으로
            self.delegate?.pushIdentifier(SignUpController(), requestDic)
        }
    }
}
