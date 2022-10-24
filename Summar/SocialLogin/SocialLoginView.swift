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
        kakaoFrame.layer.cornerRadius = 4
        kakaoFrame.tag = 0
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
        appleFrame.layer.cornerRadius = 4
        appleFrame.tag = 1
        return appleFrame
    }()
    
    let appleLabel : UILabel = {
        let appleLabel = UILabel()
        appleLabel.text = "애플계정으로 로그인"
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
        naverLabel.text = "네이버로 로그인"
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
        googleLabel.text = "구글로 로그인"
        googleLabel.textColor = .white
        googleLabel.font = .boldSystemFont(ofSize: 17.5)
        return googleLabel
    }()
    
    let googleImageView : UIImageView = {
        let googleImageView = UIImageView()
        googleImageView.image = UIImage(named: "google")
        return googleImageView
    }()
    
    let normalFrame : UIView = {
        let normalFrame = UIButton()
        normalFrame.translatesAutoresizingMaskIntoConstraints = false
        normalFrame.layer.borderWidth = 1
        normalFrame.layer.borderColor = UIColor.black.cgColor//UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1).cgColor
        normalFrame.layer.cornerRadius = 4
        normalFrame.tag = 4
        return normalFrame
    }()
    
    let normalLabel : UILabel = {
        let normalLabel = UILabel()
        normalLabel.text = "일반회원 로그인"
        normalLabel.textColor = .black
        normalLabel.font = .boldSystemFont(ofSize: 17.5)
        return normalLabel
    }()
    
    let normalImageView : UIImageView = {
        let normalImageView = UIImageView()
        normalImageView.image = UIImage(named: "normal")
        return normalImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Image View click Action
        addUITapGestureRecognizer()
        
        addSubview(self.imageView)
        
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
        
        // 일반 로그인
        addSubview(normalFrame)
        normalFrame.addSubview(normalLabel)
        normalFrame.addSubview(normalImageView)
        
        
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
        
        normalFrame.snp.makeConstraints{(make) in
            make.topMargin.equalTo(googleFrame.snp.bottom).offset(20)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
        
        normalLabel.snp.makeConstraints{(make) in
            make.centerX.equalTo(normalFrame)
            make.centerY.equalTo(normalFrame)
        }
        
        normalImageView.snp.makeConstraints{(make) in
            make.centerY.equalTo(normalFrame)
            make.leftMargin.equalTo(normalFrame.snp.left).offset(25)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
    }
    
    func addUITapGestureRecognizer(){
        let tapGesture0 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        kakaoFrame.addGestureRecognizer(tapGesture0)
        appleFrame.addGestureRecognizer(tapGesture1)
        naverFrame.addGestureRecognizer(tapGesture2)
        googleFrame.addGestureRecognizer(tapGesture3)
        normalFrame.addGestureRecognizer(tapGesture4)
    }
    
    /// 로그인 버튼 Action
    /// - Parameter sender: UI View
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if let viewTag = sender.view?.tag {
            switch viewTag {
            case 0:
                print(kakaoLabel.text!)
            case 1:
                print(appleLabel.text!)
            case 2:
                print(naverLabel.text!)
            case 3:
                print(googleLabel.text!)
            case 4:
                print(normalLabel.text!)
            default:
                print("default")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
