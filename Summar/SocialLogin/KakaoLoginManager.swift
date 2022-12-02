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

class KakaoLoginManager : NSObject {

    var returnString : String? = nil
    var identifier : String? = nil
    
    override init() {
        print(#file)
    }
    
    func kakaoLogin() -> String? {
        print("1")

            if (UserApi.isKakaoTalkLoginAvailable()) { // 카카오톡 어플이 있을 때
                print("2")
                DispatchQueue.global().sync {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        print("3")
                        if let error = error {
                            print(error)
                            self.returnString = nil
                        }else {
                            print("4")
                            self.returnString = self.getUserInfo()
                        }
                        print("5")
                    }
                    return self.returnString
                }
            } else { // 카카오톡 어플이 없을 때
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                        self.returnString = nil
                    }else {
                        self.returnString = self.getUserInfo()
                    }
                }
                return self.returnString
            }
        return nil
    }
    
    // MARK : - 해당 함수에서 회원인지 확인
    func getUserInfo() -> String? {
        print("8")
        UserApi.shared.me { User, Error in
            print("9")
            if let id = User?.id {
                print("10")
                print("id => ", id)
                self.identifier = String(id)
//                self.delegate?.pushScreen(SignUpController())
            }else {
                self.identifier = nil
            }
            print("11")
        }
        print("12")
        return self.identifier ?? nil
    }
}
