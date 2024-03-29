//
//  SocialLoginView.swift
//  Summar
//
//  Created by mac on 2022/10/18.
//

import Foundation
import UIKit
import Alamofire
import GoogleSignIn

protocol SocialLoginDelegate : class {
    func pushScreen(_ VC: UIViewController, _ requestDic: Dictionary<String, Any>)
}

final class SocialLoginView : UIView, SocialSuccessDelegate{
    weak var delegate : SocialLoginDelegate?
    
    let helper = Helper.shared
    let fontManager = FontManager.shared
    let kakaoLoginManager = KakaoLoginManager()
    let appleLoginManager = AppleLoginManager()
    let naverLoginManager = NaverLoginManager()
    let googleLoginManager = GoogleLoginManager()
    
    let label1 : UILabel = {
        let label1 = UILabel()
        label1.text = "나만의 커리어를 위한\n써머리 만들기"
        label1.textAlignment = .center
        label1.textColor = UIColor.summarColor1
        label1.font = .boldSystemFont(ofSize: 28)
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
    
    lazy var kakaoLabel : UILabel = {
        let kakaoLabel = UILabel()
        kakaoLabel.text = "카카오톡으로 시작하기"
        kakaoLabel.textColor = .black
        kakaoLabel.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
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
    
    lazy var appleLabel : UILabel = {
        let appleLabel = UILabel()
        appleLabel.text = "애플계정으로 시작하기"
        appleLabel.textColor = .white
        appleLabel.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
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
    
    lazy var naverLabel : UILabel = {
        let naverLabel = UILabel()
        naverLabel.text = "네이버로 시작하기"
        naverLabel.textColor = .white
        naverLabel.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
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
    
    lazy var googleLabel : UILabel = {
        let googleLabel = UILabel()
        googleLabel.text = "구글로 시작하기"
        googleLabel.textColor = .white
        googleLabel.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
        return googleLabel
    }()
    
    let googleImageView : UIImageView = {
        let googleImageView = UIImageView()
        googleImageView.image = UIImage(named: "google")
        return googleImageView
    }()
    
    let socialImageView : UIImageView = {
        let socialImageView = UIImageView()
        socialImageView.image = UIImage(named: "SocialLoginImage")
        socialImageView.sizeToFit()
        return socialImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        // 대리자 설정
        kakaoLoginManager.delegate = self
        appleLoginManager.delegate = self
        naverLoginManager.delegate = self
        googleLoginManager.delegate = self
        
//        naverLoginInstance?.requestDeleteToken()
        
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
//        addSubview(googleFrame)
//        googleFrame.addSubview(googleLabel)
//        googleFrame.addSubview(googleImageView)
        
        addSubview(socialImageView)
        
        
        label1.snp.makeConstraints {(make) in
            make.topMargin.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.leftMargin.equalTo(50)
            make.rightMargin.equalTo(-50)
        }
        
        socialImageView.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(kakaoFrame.snp.top).offset(0)
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
        }
        
        kakaoFrame.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(appleFrame.snp.top).offset(-20)
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
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        appleFrame.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(naverFrame.snp.top).offset(-20)
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
            make.leftMargin.equalTo(appleFrame.snp.left).offset(26)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        naverFrame.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(-70)
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
            make.leftMargin.equalTo(naverFrame.snp.left).offset(26)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
//        googleFrame.snp.makeConstraints{(make) in
//            make.bottomMargin.equalTo(-70)
//            make.leftMargin.equalTo(25)
//            make.rightMargin.equalTo(-25)
//            make.height.equalTo(52)
//        }
//
//        googleLabel.snp.makeConstraints{(make) in
//            make.centerX.equalTo(googleFrame)
//            make.centerY.equalTo(googleFrame)
//        }
//
//        googleImageView.snp.makeConstraints{(make) in
//            make.centerY.equalTo(googleFrame)
//            make.leftMargin.equalTo(googleFrame.snp.left).offset(26)
//            make.height.equalTo(30)
//            make.width.equalTo(30)
//        }
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
            case 0: //카카오톡으로 시작하기
                print(kakaoLabel.text!) // https://sujinnaljin.medium.com/ios-카카오톡-소셜-로그인-58a525e6f219
                kakaoLoginManager.kakaoLogin()
                
            case 1: // 애플계정으로 시작하기
                print(appleLabel.text!)
                appleLoginManager.appleLogin()
                
            case 2: // 네이버로 시작하기
                print(naverLabel.text!)
                naverLoginManager.naverLogin()
                
            case 3: // 구글로 시작하기
                print(googleLabel.text!)
//                googleLoginManager.googleLogin()
                
            default:
                print("default")
            }
        }
    }
    
    // MARK: - 소셜로그인 -> 회원가입 데이터 전달
    func pushIdentifier(_ VC: UIViewController,_ requestDic: Dictionary<String, Any>) {
        print(#function)
        self.delegate?.pushScreen(VC, requestDic)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

