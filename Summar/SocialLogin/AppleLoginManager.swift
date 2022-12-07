//
//  AppleLoginManager.swift
//  Summar
//
//  Created by mac on 2022/11/07.
//

import Foundation
import AuthenticationServices

class AppleLoginManager : NSObject, ServerDelegate{
    weak var viewController: UIViewController?
    weak var delegate: SocialSuccessDelegate?
    
    let request = ServerRequest()
    let helper : Helper = Helper()
    
    
    let socialType = "APPLE"
    var requestDic : Dictionary<String, String> = Dictionary<String, String>()
    
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
    
    override init() {
        super.init()
        request.delegate = self
    }
    
    func setAppleLoginPresentationAnchorView(_ view: UIViewController) {
        self.viewController = view
    }
}

extension AppleLoginManager : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController!.view.window!
    }
    
    func appleLogin(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
                
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            //    User ID : 001370.85ccb33de51e42159f1d114615cc7de5.0717
            //    User Email : wetaxmobile@gmail.com
            //    User Name : SmartWetax
            
            self.requestDic["userEmail"] = userIdentifier
            self.requestDic["userNickName"] = ""
            self.requestDic["major1"] = ""
            self.requestDic["major2"] = ""
            self.requestDic["socialType"] = self.socialType
            
            self.request.login("/user/login", self.requestDic) // 이후 memberYN으로 화면이동
        default:
            break
        }
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
    
    
    func memberYN(_ TF: Bool, _ requestDic: Dictionary<String, String>) {
        print(#file , #function)
        if TF { // 로그인 화면으로
            self.delegate?.pushIdentifier(HomeController.shared, requestDic)
        }else { // 회원가입 화면으로
            self.delegate?.pushIdentifier(SignUpController.shared, requestDic)
        }
    }
    
}
