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
        if (UserApi.isKakaoTalkLoginAvailable()) {
            print("!!!!!!!!!!!!!!!!!!!!!!")
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                print("@@@@@@@@@@@@@@@@@@@@")
                print("loginWithKakaoTalk oauthToken =>\n", oauthToken)
                if let oauthToken = oauthToken {
                    self.getUserInfo()
                }
                print("loginWithKakaoAccount error =>\n", error)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                print("##################")
                print("loginWithKakaoAccount oauthToken =>\n", oauthToken)
                if let oauthToken = oauthToken {
                    self.getUserInfo()
                }
                print("loginWithKakaoAccount error =>\n", error)
            }
        }
    }
    
    func getUserInfo() {
        UserApi.shared.me { User, Error in
            if let id = User?.id {
                print("id => ", id)
            }
            
             if let name = User?.kakaoAccount?.profile?.nickname {
//                userName = name
                 print("name => ", name)
             }
             if let mail = User?.kakaoAccount?.email {
//                userMail = mail
                 print("mail => ", mail)
             }
             if let profile = User?.kakaoAccount?.profile?.profileImageUrl {
//                profileImage = profile
                 print("profile => ", profile)
             }
        }
    }
}
