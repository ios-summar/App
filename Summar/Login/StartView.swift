//
//  StartView.swift
//  Summar
//
//  Created by ukBook on 2022/10/16.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import AuthenticationServices // 애플 로그인 https://huisoo.tistory.com/3

protocol Delegate : class {
    func pushScreen(_ viewC: UIViewController)
}

/// => 앱 최초설치   스플레시 스크린 ->  시작 화면
class StartView : UIView {
    
    weak var delegate : Delegate?
    
    let helper : Helper = Helper()
    
    let label1 : UILabel = {
        let label1 = UILabel()
        label1.text = "나만의 커리어를 위한\n 포트폴리오 만들기"
        label1.textAlignment = .center
        label1.textColor = UIColor.summarColor1
        label1.font = .boldSystemFont(ofSize: 30)
        label1.numberOfLines = 2
        label1.sizeToFit()
        return label1
    }()
    
    let label2 : UILabel = {
        let label2 = UILabel()
        label2.text = "써머랑 함께 스펙 더하기!"
        label2.textAlignment = .center
        label2.textColor = UIColor.summarColor1
        label2.font = .systemFont(ofSize: 20 )
        label2.numberOfLines = 0
        label2.sizeToFit()
        return label2
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "SignUpImage")
        
        return imageView
    }()
    
    
    let nextBtn : UIButton = {
        let nextBtn = UIButton()
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.backgroundColor = UIColor.summarColor2
        nextBtn.layer.cornerRadius = 4
        nextBtn.setTitle("시작해볼까요?", for: .normal)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        return nextBtn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        addSubview(imageView)
        addSubview(label1)
        addSubview(label2)
        
        addSubview(nextBtn)
        
        label1.snp.makeConstraints{(make) in
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.topMargin.equalTo(30)
        }
        
        label2.snp.makeConstraints{(make) in
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.topMargin.equalTo(label1.snp.bottom).offset(30)
        } 
        
        imageView.snp.makeConstraints {(make) in
            make.topMargin.equalTo(label2.snp.bottom).offset(70)
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(166)
        }
        
        nextBtn.snp.makeConstraints {(make) in
            make.bottomMargin.equalTo(-135)
            make.leftMargin.equalTo(20)
            make.rightMargin.equalTo(-20)
            make.height.equalTo(52)
        }
        
    }
    
    @objc func btnAction(_ sender: Any){
        print(#function)
        delegate?.pushScreen(SocialLoginController())
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

