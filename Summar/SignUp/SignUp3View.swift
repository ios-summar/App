//
//  SignUp3View.swift
//  Summar
//
//  Created by mac on 2022/10/27.
//

import Foundation
import UIKit
import SnapKit

final class SignUp3View : UIView {
    let helper = Helper()
    
    let btnWidth : CGFloat = {
        var btnWidth = UIScreen.main.bounds.width
        btnWidth -= 100
        return btnWidth
    }()
    
    let btnHeight : CGFloat = {
        var btnHeight = UIScreen.main.bounds.width
        btnHeight -= 150
        return btnHeight
    }()
    
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.text = "써머랑 함께 그로우업!"
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.summarColor1
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    let subTitle : UILabel = {
        let label2 = UILabel()
        label2.text = "회원이 되신것을 축하드립니다"
        label2.textAlignment = .center
        label2.textColor = UIColor.summarColor1
        label2.font = .systemFont(ofSize: 19)
        label2.numberOfLines = 0
        label2.sizeToFit()
        return label2
    }()
    
    let signUpImage : UIImageView = {
        let SignUpImage = UIImageView()
        SignUpImage.image = UIImage(named: "SignUpImage 300x249.23")
        SignUpImage.sizeToFit()
        return SignUpImage
    }()
    
    let goBtn : UIButton = {
        let goBtn = UIButton()
        goBtn.translatesAutoresizingMaskIntoConstraints = false
        goBtn.setTitle("지금 바로 시작해볼까요?", for: .normal)
        goBtn.setTitleColor(.white, for: .normal)
        goBtn.titleLabel?.font = .systemFont(ofSize: 18)
        goBtn.backgroundColor = UIColor.summarColor2
        goBtn.layer.cornerRadius = 4
        goBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return goBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subTitle)
        addSubview(signUpImage)
        addSubview(goBtn)
        backgroundColor = .white

        titleLabel.snp.makeConstraints{(make) in
            make.topMargin.equalTo(50)
            make.leftMargin.equalTo(50)
            make.rightMargin.equalTo(-50)
            make.height.equalTo(34)
        }
        
        subTitle.snp.makeConstraints{(make) in
            make.topMargin.equalTo(titleLabel.snp.bottom).offset(10)
            make.leftMargin.equalTo(68)
            make.rightMargin.equalTo(-68)
            make.height.equalTo(34)
        }
        
        signUpImage.snp.makeConstraints{(make) in
            make.topMargin.equalTo(subTitle.snp.bottom).offset(70)
            make.centerX.equalTo(subTitle.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(249.23)
        }
        
        goBtn.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(-50)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
    }
    
    @objc func nextAction(){
        print(#file , #function)
        let VC = HomeController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(VC, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
