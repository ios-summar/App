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
    override init() {
        print(#file)
    }
    
    func kakaoLogin() {
        print(#function)
        if (UserApi.isKakaoTalkLoginAvailable()) { // 카카오톡 어플이 있을 때
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                   print(error)
                }else {
                    self.getUserInfo()
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
    
    func getUserInfo() {
        UserApi.shared.me { User, Error in
            if let id = User?.id {
                print("id => ", id)
            }
            if let name = User?.kakaoAccount?.profile?.nickname {
                print("name => ", name)
            }
            if let mail = User?.kakaoAccount?.email {
                print("mail => ", mail)
            }
            if let profile = User?.kakaoAccount?.profile?.profileImageUrl {
                print("profile => ", profile)
            }
        }
    }
}
