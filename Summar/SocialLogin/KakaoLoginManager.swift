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
    func pushIdentifier(_ VC: UIViewController,_ identifier: String?)
}

class KakaoLoginManager : NSObject {
    
    weak var delegate : SocialSuccessDelegate?
    
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
                self.delegate?.pushIdentifier(SignUpController.shared, String(id))
            }else {
                print(Error)
            }
        }
    }
}
