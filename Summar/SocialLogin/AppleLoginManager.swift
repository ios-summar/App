//
//  AppleLoginManager.swift
//  Summar
//
//  Created by mac on 2022/11/07.
//

import Foundation
import AuthenticationServices

class AppleLoginManager : NSObject{
    weak var viewController: UIViewController?
//    weak var delegate: AppleLoginManagerDelegate?
    
    let helper : Helper = Helper()
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
            
            requestGETCheckId(requestUrl: "/user/userIdCheck/\(userIdentifier)")
        default:
            break
        }
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
    
    func requestGETCheckId(requestUrl : String!){
        // URL 객체 정의
//                let url = URL(string: serverURL()+requestUrl)
                let urlStr = self.serverURL()+requestUrl
                print(urlStr)
                let encoded = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let myURL = URL(string: encoded!)
                // URLRequest 객체를 정의
                var request = URLRequest(url: myURL!)
                request.httpMethod = "GET"

                // HTTP 메시지 헤더
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    // 서버가 응답이 없거나 통신이 실패
                    if let e = error {
                        self.helper.showAlert(vc: SocialLoginView(), message: "네트워크 상태를 확인해주세요.\n\(e)")
                    }

                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("responseString\n",responseString!)
                    DispatchQueue.main.async {
                        if responseString! == "true"{ // 회원가입 이력 있음
                            self.moveScreen(HomeController())
                        }else { // 회원가입 이력 없음
                            self.moveScreen(SignUpController())
                        }
                    }
                }
                task.resume()
    }
    
    func moveScreen(_ viewC: UIViewController) {
//        self.navigationController?.pushViewController(viewC, animated: true)
        print(viewC)
        print(self.viewController?.navigationController)
        self.viewController?.navigationController?.pushViewController(viewC, animated: true)
    }
}
