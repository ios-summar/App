//
//  SocialLoginView.swift
//  Summar
//
//  Created by mac on 2022/10/18.
//

import Foundation
import UIKit
import AuthenticationServices
import NaverThirdPartyLogin
import Alamofire

protocol SocialLoginDelegate : class {
    func moveScreen(storyboard: String, controller: String)
}

class SocialLoginView : UIView{
    
    weak var delegate : SocialLoginDelegate?
    
    let helper : Helper = Helper()
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
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
    
//    let imageView : UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "SignUpImage")
//        return imageView
//    }()
    
    let label1 : UILabel = {
        let label1 = UILabel()
        label1.text = "써머와 함께\n나만의 커리어를 위한\n포트폴리오를 만들어 볼까요?"
        label1.textAlignment = .left
        label1.textColor = UIColor.summarColor1
        label1.font = .boldSystemFont(ofSize: 24)
        label1.numberOfLines = 0
        label1.sizeToFit()
        return label1
    }()
    
    let kakaoFrame : UIView = {
        let kakaoFrame = UIView()
        kakaoFrame.translatesAutoresizingMaskIntoConstraints = false
        kakaoFrame.backgroundColor = UIColor.kakaoColor
        kakaoFrame.layer.cornerRadius = 4
        kakaoFrame.tag = 0
        return kakaoFrame
    }()
    
    let kakaoLabel : UILabel = {
        let kakaoLabel = UILabel()
        kakaoLabel.text = "카카오톡으로 시작하기"
        kakaoLabel.textColor = .black
        kakaoLabel.font = .boldSystemFont(ofSize: 17.5)
        return kakaoLabel
    }()
    
    let kakaoImageView : UIImageView = {
        let kakaoImageView = UIImageView()
        kakaoImageView.image = UIImage(named: "kakao")
        return kakaoImageView
    }()
    
    let appleFrame : UIView = {
        let appleFrame = UIView()
        appleFrame.translatesAutoresizingMaskIntoConstraints = false
        appleFrame.backgroundColor = UIColor.appleColor
        appleFrame.layer.cornerRadius = 4
        appleFrame.tag = 1
        return appleFrame
    }()
    
    let appleLabel : UILabel = {
        let appleLabel = UILabel()
        appleLabel.text = "애플계정으로 시작하기"
        appleLabel.textColor = .white
        appleLabel.font = .boldSystemFont(ofSize: 17.5)
        return appleLabel
    }()
    
    let appleImageView : UIImageView = {
        let appleImageView = UIImageView()
        appleImageView.image = UIImage(named: "apple")
        return appleImageView
    }()
    
    let naverFrame : UIView = {
        let naverFrame = UIButton()
        naverFrame.translatesAutoresizingMaskIntoConstraints = false
        naverFrame.backgroundColor = UIColor.naverColor
        naverFrame.layer.cornerRadius = 4
        naverFrame.tag = 2
        return naverFrame
    }()
    
    let naverLabel : UILabel = {
        let naverLabel = UILabel()
        naverLabel.text = "네이버로 시작하기"
        naverLabel.textColor = .white
        naverLabel.font = .boldSystemFont(ofSize: 17.5)
        return naverLabel
    }()
    
    let naverImageView : UIImageView = {
        let naverImageView = UIImageView()
        naverImageView.image = UIImage(named: "naver")
        return naverImageView
    }()
    
    let googleFrame : UIView = {
        let googleFrame = UIButton()
        googleFrame.translatesAutoresizingMaskIntoConstraints = false
        googleFrame.backgroundColor = UIColor.googleColor
        googleFrame.layer.cornerRadius = 4
        googleFrame.tag = 3
        return googleFrame
    }()
    
    let googleLabel : UILabel = {
        let googleLabel = UILabel()
        googleLabel.text = "구글로 시작하기"
        googleLabel.textColor = .white
        googleLabel.font = .boldSystemFont(ofSize: 17.5)
        return googleLabel
    }()
    
    let googleImageView : UIImageView = {
        let googleImageView = UIImageView()
        googleImageView.image = UIImage(named: "google")
        return googleImageView
    }()
    
    let notLogin : UIButton = {
        let notLogin = UIButton()
        notLogin.setTitleColor(UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1), for: .normal)
        notLogin.tintColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        notLogin.setTitle("그냥 둘러볼래요   ", for: .normal)
        notLogin.titleLabel?.font = .systemFont(ofSize: 15)
        notLogin.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        notLogin.semanticContentAttribute = .forceRightToLeft
        return notLogin
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        naverLoginInstance?.requestDeleteToken()
        
        //Image View click Action
        addUITapGestureRecognizer()
        
        addSubview(label1)
        
        // 카카오 로그인
        addSubview(kakaoFrame)
        kakaoFrame.addSubview(kakaoLabel)
        kakaoFrame.addSubview(kakaoImageView)
        
        // 애플 로그인
        addSubview(appleFrame)
        appleFrame.addSubview(appleLabel)
        appleFrame.addSubview(appleImageView)
        
        // 네이버 로그인
        addSubview(naverFrame)
        naverFrame.addSubview(naverLabel)
        naverFrame.addSubview(naverImageView)
        
        // 구글 로그인
        addSubview(googleFrame)
        googleFrame.addSubview(googleLabel)
        googleFrame.addSubview(googleImageView)
        
        addSubview(notLogin)
        
        
        label1.snp.makeConstraints {(make) in
            make.topMargin.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.leftMargin.equalTo(50)
            make.rightMargin.equalTo(-50)
        }
        
        kakaoFrame.snp.makeConstraints{(make) in
            make.topMargin.equalTo(label1.snp.bottom).offset(120)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
        
        kakaoLabel.snp.makeConstraints{(make) in
            make.centerX.equalTo(kakaoFrame)
            make.centerY.equalTo(kakaoFrame)
        }
        
        kakaoImageView.snp.makeConstraints{(make) in
            make.centerY.equalTo(kakaoFrame)
            make.leftMargin.equalTo(kakaoFrame.snp.left).offset(26)
            make.height.equalTo(19.71)
            make.width.equalTo(20)
        }
        
        appleFrame.snp.makeConstraints{(make) in
            make.topMargin.equalTo(kakaoFrame.snp.bottom).offset(20)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
        
        appleLabel.snp.makeConstraints{(make) in
            make.centerX.equalTo(appleFrame)
            make.centerY.equalTo(appleFrame)
        }
        
        appleImageView.snp.makeConstraints{(make) in
            make.centerY.equalTo(appleFrame)
            make.leftMargin.equalTo(appleFrame.snp.left).offset(27)
            make.height.equalTo(20)
            make.width.equalTo(17)
        }
        
        naverFrame.snp.makeConstraints{(make) in
            make.topMargin.equalTo(appleFrame.snp.bottom).offset(20)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
        
        naverLabel.snp.makeConstraints{(make) in
            make.centerX.equalTo(naverFrame)
            make.centerY.equalTo(naverFrame)
        }
        
        naverImageView.snp.makeConstraints{(make) in
            make.centerY.equalTo(naverFrame)
            make.leftMargin.equalTo(naverFrame.snp.left).offset(27)
            make.height.equalTo(16)
            make.width.equalTo(16)
        }
        
        googleFrame.snp.makeConstraints{(make) in
            make.topMargin.equalTo(naverFrame.snp.bottom).offset(20)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
        
        googleLabel.snp.makeConstraints{(make) in
            make.centerX.equalTo(googleFrame)
            make.centerY.equalTo(googleFrame)
        }
        
        googleImageView.snp.makeConstraints{(make) in
            make.centerY.equalTo(googleFrame)
            make.leftMargin.equalTo(googleFrame.snp.left).offset(25)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        notLogin.snp.makeConstraints{(make) in
            make.topMargin.equalTo(googleFrame.snp.bottom).offset(20)
            make.rightMargin.equalTo(-25)
        }
        
    }
    
    func addUITapGestureRecognizer(){
        let tapGesture0 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        kakaoFrame.addGestureRecognizer(tapGesture0)
        appleFrame.addGestureRecognizer(tapGesture1)
        naverFrame.addGestureRecognizer(tapGesture2)
        googleFrame.addGestureRecognizer(tapGesture3)
    }
    
    /// 로그인 버튼 Action
    /// - Parameter sender: UI View
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if let viewTag = sender.view?.tag {
            switch viewTag {
            case 0:
                print(kakaoLabel.text!) // https://sujinnaljin.medium.com/ios-카카오톡-소셜-로그인-58a525e6f219
            case 1:
                print(appleLabel.text!)
                appleLogin()
            case 2:
                print(naverLabel.text!)
                naverLoginInstance?.delegate = self
                naverLoginInstance?.requestThirdPartyLogin()
            case 3:
                print(googleLabel.text!)
            default:
                print("default")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SocialLoginView : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, NaverThirdPartyLoginConnectionDelegate  {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window!
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
                        self.helper.showAlert(vc: self, message: "네트워크 상태를 확인해주세요.\n\(e)")
                    }

                    var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(responseString!)
                    DispatchQueue.main.async {
                        if responseString! == "true"{ // 회원가입 이력 있음
                            self.delegate?.moveScreen(storyboard: "Home", controller: "HomeController")
                        }else { // 회원가입 이력 없음
                            self.delegate?.moveScreen(storyboard: "SignUp", controller: "SignUpController")
                        }
                    }
                }
                task.resume()
    }
    
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print(#function)
        getNaverInfo()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print(#function)
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print(#function)
        naverLoginInstance?.requestDeleteToken()
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }
    
    private func getNaverInfo() {
        guard let isValidAccessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
          return
        }
        
        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            print(response.value!)
              guard let result = response.value as? [String: Any] else { return }
              guard let object = result["response"] as? [String: Any] else { return }
            
            print("result =>", result)
            
            print("result1 =>", result["message"])
            print("result2 =>", result["resultcode"])
            
            print("object =>", object)
            
            print(object["email"] ?? "")
            print(object["id"] ?? "")
            print(object["nickname"] ?? nil)
            print(object["profile_image"] ?? nil)
              
            }
      }
    
}
