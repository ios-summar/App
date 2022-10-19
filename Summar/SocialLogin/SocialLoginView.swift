//
//  SocialLoginView.swift
//  Summar
//
//  Created by mac on 2022/10/18.
//

import Foundation
import UIKit

class SocialLoginView : UIView {
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "SignUpImage")
        return imageView
    }()
    
    let kakaoFrame : UIView = {
        let kakaoFrame = UIView()
        kakaoFrame.translatesAutoresizingMaskIntoConstraints = false
        kakaoFrame.backgroundColor = UIColor.kakaoColor
//        kakaoLoginBtn.setTitleColor(.black, for: .normal)
//        kakaoLoginBtn.setTitle("카카오톡으로 로그인", for: .normal)
//        kakaoLoginBtn.titleLabel?.font = .boldSystemFont(ofSize: 17.5)
//        kakaoLoginBtn.setImage(UIImage(named: "kakao"), for: .normal)
        kakaoFrame.layer.cornerRadius = 4
        return kakaoFrame
    }()
    
    let kakaoLabel : UILabel = {
        let kakaoLabel = UILabel()
        kakaoLabel.text = "카카오톡으로 로그인"
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
        let appleFrame = UIButton()
        appleFrame.translatesAutoresizingMaskIntoConstraints = false
        appleFrame.backgroundColor = UIColor.appleColor
//        appleLoginBtn.setTitleColor(.white, for: .normal)
//        appleLoginBtn.setTitle("애플계정으로 로그인", for: .normal)
//        appleLoginBtn.titleLabel?.font = .boldSystemFont(ofSize: 17.5)
//        appleLoginBtn.setImage(UIImage(named: "apple"), for: .normal)
        appleFrame.layer.cornerRadius = 4
        return appleFrame
    }()
    
    let naverFrame : UIView = {
        let naverFrame = UIButton()
        naverFrame.translatesAutoresizingMaskIntoConstraints = false
        naverFrame.backgroundColor = UIColor.naverColor
//        naverLoginBtn.setTitleColor(.white, for: .normal)
//        naverLoginBtn.setTitle("네이버로 로그인", for: .normal)
//        naverLoginBtn.titleLabel?.font = .boldSystemFont(ofSize: 17.5)
//        naverLoginBtn.setImage(UIImage(named: "naver"), for: .normal)
        naverFrame.layer.cornerRadius = 4
        return naverFrame
    }()
    
    let googleFrame : UIView = {
        let googleLoginBtn = UIButton()
        googleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        googleLoginBtn.backgroundColor = UIColor.googleColor
//        googleLoginBtn.setTitleColor(.white, for: .normal)
//        googleLoginBtn.setTitle("구글로 로그인", for: .normal)
//        googleLoginBtn.titleLabel?.font = .boldSystemFont(ofSize: 17.5)
//        googleLoginBtn.setImage(UIImage(named: "google"), for: .normal)
        googleLoginBtn.layer.cornerRadius = 4
        return googleLoginBtn
    }()
    
    let normalFrame : UIView = {
        let normalFrame = UIButton()
        normalFrame.translatesAutoresizingMaskIntoConstraints = false
        normalFrame.layer.borderWidth = 1
        normalFrame.layer.borderColor = UIColor.black.cgColor//UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1).cgColor
//        normalLoginBtn.setTitleColor(.black, for: .normal)
//        normalLoginBtn.setTitle("일반회원 로그인", for: .normal)
//        normalLoginBtn.titleLabel?.font = .boldSystemFont(ofSize: 17.5)
//        normalLoginBtn.setImage(UIImage(named: "normal"), for: .normal)
        normalFrame.layer.cornerRadius = 4
        return normalFrame
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(self.imageView)
        
        // 소셜로그인 Frame
        addSubview(kakaoFrame)
        kakaoFrame.addSubview(kakaoLabel)
        kakaoFrame.addSubview(kakaoImageView)
        
        addSubview(appleFrame)
        addSubview(naverFrame)
        addSubview(googleFrame)
        addSubview(normalFrame)
        
        
        
        imageView.snp.makeConstraints {(make) in
            make.topMargin.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(166)
        }
        
        kakaoFrame.snp.makeConstraints{(make) in
            make.topMargin.equalTo(imageView.snp.bottom).offset(60)
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
            make.leftMargin.equalTo(kakaoFrame.snp.left).offset(25)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        appleFrame.snp.makeConstraints{(make) in
            make.topMargin.equalTo(kakaoFrame.snp.bottom).offset(20)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
        
        naverFrame.snp.makeConstraints{(make) in
            make.topMargin.equalTo(appleFrame.snp.bottom).offset(20)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
        
        googleFrame.snp.makeConstraints{(make) in
            make.topMargin.equalTo(naverFrame.snp.bottom).offset(20)
            
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
        
        normalFrame.snp.makeConstraints{(make) in
            make.topMargin.equalTo(googleFrame.snp.bottom).offset(20)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
