//
//  SignUp1View.swift
//  Summar
//
//  Created by ukBook on 2022/10/23.
//

import Foundation
import UIKit
import SnapKit

class SignUp1View : UIView {

    let viewWidth : CGFloat = {
        // 뷰 전체 폭 길이
        var screenWidth = UIScreen.main.bounds.size.width
        var divScreen = screenWidth / 3 - 30
        return divScreen
    }()
    
    let viewLine1 : UIView = {
        let viewLine1 = UIView()
        viewLine1.translatesAutoresizingMaskIntoConstraints = false
        viewLine1.backgroundColor = UIColor.summarColor2
        return viewLine1
    }()
    
    let viewLine2 : UIView = {
        let viewLine2 = UIView()
        viewLine2.translatesAutoresizingMaskIntoConstraints = false
        viewLine2.backgroundColor = UIColor.grayColor205
        return viewLine2
    }()
    
    let viewLine3 : UIView = {
        let viewLine3 = UIView()
        viewLine3.translatesAutoresizingMaskIntoConstraints = false
        viewLine3.backgroundColor = UIColor.grayColor205
        return viewLine3
    }()
    
    var checkboxAll : UIImageView = {
        let checkboxAll = UIImageView()
        checkboxAll.translatesAutoresizingMaskIntoConstraints = false
        checkboxAll.image = UIImage(systemName: "square") //checkmark.square
        checkboxAll.tintColor = UIColor.grayColor197
        return checkboxAll
    }()
    
    var checkboxAllBtn : UIButton = {
        let checkboxAllBtn = UIButton()
        checkboxAllBtn.translatesAutoresizingMaskIntoConstraints = false
        checkboxAllBtn.setTitle("전체 약관동의", for: .normal)
        checkboxAllBtn.setTitleColor(.black, for: .normal)
        checkboxAllBtn.titleLabel?.font = .systemFont(ofSize: 18)
        checkboxAllBtn.sizeToFit()
        return checkboxAllBtn
    }()
    
    var checkbox1 : UIImageView = {
        let checkbox1 = UIImageView()
        checkbox1.translatesAutoresizingMaskIntoConstraints = false
        checkbox1.image = UIImage(systemName: "square") //checkmark.square
        checkbox1.tintColor = UIColor.grayColor197
        return checkbox1
    }()
    
    let checkboxBtn1 : UIButton = {
        let checkboxBtn1 = UIButton()
        checkboxBtn1.translatesAutoresizingMaskIntoConstraints = false
        checkboxBtn1.setTitle("[필수] 써머 이용약관", for: .normal)
        checkboxBtn1.setTitleColor(.black, for: .normal)
        checkboxBtn1.titleLabel?.font = .systemFont(ofSize: 15)
        checkboxBtn1.sizeToFit()
        return checkboxBtn1
    }()
    
    let contentBtn1 : UIButton = {
        let contentBtn1 = UIButton()
        contentBtn1.translatesAutoresizingMaskIntoConstraints = false
        contentBtn1.setTitle("내용보기", for: .normal)
        contentBtn1.setTitleColor(UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1), for: .normal)
        contentBtn1.titleLabel?.font = .systemFont(ofSize: 13)
        contentBtn1.sizeToFit()
        return contentBtn1
    }()
    
    let viewLine4 : UIView = {
        let viewLine1 = UIView()
        viewLine1.translatesAutoresizingMaskIntoConstraints = false
        viewLine1.backgroundColor = UIColor.grayColor197
        return viewLine1
    }()
    
    var checkbox2 : UIImageView = {
        let checkbox2 = UIImageView()
        checkbox2.translatesAutoresizingMaskIntoConstraints = false
        checkbox2.image = UIImage(systemName: "square") //checkmark.square
        checkbox2.tintColor = UIColor.grayColor197
        return checkbox2
    }()
    
    let checkboxBtn2 : UIButton = {
        let checkboxBtn2 = UIButton()
        checkboxBtn2.translatesAutoresizingMaskIntoConstraints = false
        checkboxBtn2.setTitle("[필수] 개인정보수집동의", for: .normal)
        checkboxBtn2.setTitleColor(.black, for: .normal)
        checkboxBtn2.titleLabel?.font = .systemFont(ofSize: 15)
        checkboxBtn2.sizeToFit()
        return checkboxBtn2
    }()
    
    let contentBtn2 : UIButton = {
        let contentBtn2 = UIButton()
        contentBtn2.translatesAutoresizingMaskIntoConstraints = false
        contentBtn2.setTitle("내용보기", for: .normal)
        contentBtn2.setTitleColor(UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1), for: .normal)
        contentBtn2.titleLabel?.font = .systemFont(ofSize: 13)
        contentBtn2.sizeToFit()
        return contentBtn2
    }()
    
    let viewLine5 : UIView = {
        let viewLine1 = UIView()
        viewLine1.translatesAutoresizingMaskIntoConstraints = false
        viewLine1.backgroundColor = UIColor.grayColor197
        return viewLine1
    }()
    
    var checkbox3 : UIImageView = {
        let checkbox3 = UIImageView()
        checkbox3.translatesAutoresizingMaskIntoConstraints = false
        checkbox3.image = UIImage(systemName: "square") //checkmark.square
        checkbox3.tintColor = UIColor.grayColor197
        return checkbox3
    }()
    
    let checkboxBtn3 : UIButton = {
        let checkboxBtn3 = UIButton()
        checkboxBtn3.translatesAutoresizingMaskIntoConstraints = false
        checkboxBtn3.setTitle("[선택] 마케팅 정보 수신 약관", for: .normal)
        checkboxBtn3.setTitleColor(.black, for: .normal)
        checkboxBtn3.titleLabel?.font = .systemFont(ofSize: 15)
        checkboxBtn3.sizeToFit()
        return checkboxBtn3
    }()
    
    let contentBtn3 : UIButton = {
        let contentBtn3 = UIButton()
        contentBtn3.translatesAutoresizingMaskIntoConstraints = false
        contentBtn3.setTitle("내용보기", for: .normal)
        contentBtn3.setTitleColor(UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1), for: .normal)
        contentBtn3.titleLabel?.font = .systemFont(ofSize: 13)
        contentBtn3.sizeToFit()
        return contentBtn3
    }()
    
    let viewLine6 : UIView = {
        let viewLine1 = UIView()
        viewLine1.translatesAutoresizingMaskIntoConstraints = false
        viewLine1.backgroundColor = UIColor.grayColor197
        return viewLine1
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print(viewWidth)
        
        addSubview(viewLine1)
        addSubview(viewLine2)
        addSubview(viewLine3)
        
        addSubview(checkboxAll)
        addSubview(checkboxAllBtn)
        
        addSubview(checkbox1)
        addSubview(checkboxBtn1)
        addSubview(contentBtn1)
        addSubview(viewLine4)
        
        addSubview(checkbox2)
        addSubview(checkboxBtn2)
        addSubview(contentBtn2)
        addSubview(viewLine5)
        
        addSubview(checkbox3)
        addSubview(checkboxBtn3)
        addSubview(contentBtn3)
        addSubview(viewLine6)
        
        // 상단 프로세스 바
        viewLine2.snp.makeConstraints {(make) in
            make.topMargin.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(viewWidth)
            make.height.equalTo(2)
        }
        
        viewLine1.snp.makeConstraints {(make) in
            make.centerY.equalTo(viewLine2.snp.centerY)
            make.rightMargin.equalTo(viewLine2.snp.left).offset(-20)
            make.width.equalTo(viewWidth)
            make.height.equalTo(2)
        }
        
        viewLine3.snp.makeConstraints {(make) in
            make.centerY.equalTo(viewLine2.snp.centerY)
            make.leftMargin.equalTo(viewLine2.snp.right).offset(20)
            make.width.equalTo(viewWidth)
            make.height.equalTo(2)
        }
        //
        
        // 전체 약관동의
        checkboxAll.snp.makeConstraints{(make) in
            make.topMargin.equalTo(viewLine1).offset(62)
            make.leftMargin.equalTo(25)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }

        checkboxAllBtn.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkboxAll.snp.centerY)
            make.leftMargin.equalTo(checkboxAll.snp.right).offset(20)
            make.height.equalTo(19)
        }
        //
        
        //[필수] 써머 이용약관
        checkbox1.snp.makeConstraints{(make) in
            make.topMargin.equalTo(checkboxAll.snp.bottom).offset(40)
            make.leftMargin.equalTo(35)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        checkboxBtn1.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkbox1.snp.centerY)
            make.leftMargin.equalTo(checkbox1.snp.right).offset(20)
            make.height.equalTo(8)
        }
        
        contentBtn1.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkboxBtn1.snp.centerY)
            make.rightMargin.equalTo(-52)
            make.height.equalTo(14)
        }
        
        viewLine4.snp.makeConstraints{(make) in
            make.topMargin.equalTo(checkboxBtn1.snp.bottom).offset(30)
            make.leftMargin.equalTo(35)
            make.rightMargin.equalTo(-35)
            make.height.equalTo(1)
        }
        //
        
        //[필수] 개인정보 수집 및 이용에 대한 안내
        checkbox2.snp.makeConstraints{(make) in
            make.topMargin.equalTo(viewLine4.snp.bottom).offset(40)
            make.leftMargin.equalTo(35)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        checkboxBtn2.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkbox2.snp.centerY)
            make.leftMargin.equalTo(checkbox2.snp.right).offset(20)
            make.height.equalTo(8)
        }

        contentBtn2.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkboxBtn2.snp.centerY)
            make.rightMargin.equalTo(-52)
            make.height.equalTo(14)
        }

        viewLine5.snp.makeConstraints{(make) in
            make.topMargin.equalTo(checkboxBtn2.snp.bottom).offset(30)
            make.leftMargin.equalTo(35)
            make.rightMargin.equalTo(-35)
            make.height.equalTo(1)
        }
        //
        
        //[선택] 마케팅 정보 수신 약관
        checkbox3.snp.makeConstraints{(make) in
            make.topMargin.equalTo(viewLine5.snp.bottom).offset(40)
            make.leftMargin.equalTo(35)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        checkboxBtn3.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkbox3.snp.centerY)
            make.leftMargin.equalTo(checkbox3.snp.right).offset(20)
            make.height.equalTo(8)
        }

        contentBtn3.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkboxBtn3.snp.centerY)
            make.rightMargin.equalTo(-52)
            make.height.equalTo(14)
        }

        viewLine6.snp.makeConstraints{(make) in
            make.topMargin.equalTo(checkboxBtn3.snp.bottom).offset(30)
            make.leftMargin.equalTo(35)
            make.rightMargin.equalTo(-35)
            make.height.equalTo(1)
        }
        //
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
