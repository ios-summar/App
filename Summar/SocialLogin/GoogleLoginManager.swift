//
//  GoogleLoginManager.swift
//  Summar
//
//  Created by mac on 2022/11/07.
//

import Foundation
import GoogleSignIn

class GoogleLoginManager: NSObject {
    func googleLogin() {
//        GIDSignIn.sharedInstance.presentingViewController = self
//        GIDSignIn.sharedInstance.delegate = self
//        googleSignInButton.style = .standard // .wide .iconOnly
    }
    
    // 연동을 시도 했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInError.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
            
        // 사용자 정보 가져오기
        if let userId = user.userID,                  // For client-side use only!
            let idToken = user.authentication.idToken, // Safe to send to the server
            let fullName = user.profile?.name,
            let givenName = user.profile?.givenName,
            let familyName = user.profile?.familyName,
            let email = user.profile?.email {
                
            print("Token : \(idToken)")
            print("User ID : \(userId)")
            print("User Email : \(email)")
            print("User Name : \((fullName))")

        } else {
            print("Error : User Data Not Found")
        }
    }
        
    // 구글 로그인 연동 해제했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
}
