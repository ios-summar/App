//
//  GoogleLoginManager.swift
//  Summar
//
//  Created by mac on 2022/11/07.
//

import Foundation
import GoogleSignIn

final class GoogleLoginManager: NSObject{
    
    weak var delegate : SocialSuccessDelegate?
    
    let helper = Helper()
    let request = ServerRequest.shared
    
    let socialType = "GOOGLE"
    var requestDic : Dictionary<String, String> = Dictionary<String, String>()
    
    override init() {
        super.init()
    }
    
    // MARK: - 구글 로그인
    func googleLogin() {
        
        let config = GIDConfiguration(clientID: "889837360140-sbhsh841die0v2gd36muj7e4qj9f0lad.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: config, presenting: UIApplication.topViewController()!) { user, error in
            if let error = error {
                if (error as NSError).code == GIDSignInError.hasNoAuthInKeychain.rawValue {
                    print("The user has not signed in before or they have since signed out.")
                } else {
                    print("else Error => \n\(error.localizedDescription)")
                }
                return
            }
                
            // 사용자 정보 가져오기
            if let userId = user?.userID,                  // For client-side use only!
                let idToken = user?.authentication.idToken, // Safe to send to the server
                let fullName = user?.profile?.name,
                let givenName = user?.profile?.givenName,
                let familyName = user?.profile?.familyName,
                let email = user?.profile?.email {
                    
                print("Token : \(idToken)")
                print("User ID : \(userId)")
                print("User Email : \(email)")
                print("User Name : \((fullName))")
                
                self.requestDic["userEmail"] = userId
                self.requestDic["userNickname"] = ""
                self.requestDic["major1"] = ""
                self.requestDic["major2"] = ""
                self.requestDic["socialType"] = self.socialType
                
                self.request.login("/user/login", self.requestDic, completion: { (login, param) in
                    guard let login = login else {return}
                    self.memberYN(login, param)
                })
                
            } else {
                print("Error : User Data Not Found")
            }
        }
    }
        
    // MARK: - 구글 로그인 연동 해제했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
    
    // MARK: - 화면이동 Delegate
    func memberYN(_ TF: Bool,_ requestDic: Dictionary<String, Any>) {
        print(#file , #function)
        if TF { // 로그인 화면으로
            self.delegate?.pushIdentifier(HomeController.shared, requestDic)
        }else { // 회원가입 화면으로
            self.delegate?.pushIdentifier(SignUpController.shared, requestDic)
        }
    }
}
