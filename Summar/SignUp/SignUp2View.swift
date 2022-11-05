//
//  SignUp2View.swift
//  Summar
//
//  Created by mac on 2022/10/25.
//

import Foundation
import SnapKit

class SignUp2View : UIView{
    
    let helper = Helper()
    let btnWidth : CGFloat = {
        var btnWidth = UIScreen.main.bounds.width
        return btnWidth / 3 - 20
    }()
    
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "전공 또는\n학위를 입력해주세요"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.summarColor1
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.sizeToFit()
        return titleLabel
    }()
    
    let majorTextField : UITextField = {
        let majorTextField = UITextField()
        majorTextField.translatesAutoresizingMaskIntoConstraints = false
        majorTextField.layer.borderWidth = 1
        majorTextField.layer.borderColor = UIColor.white.cgColor
        majorTextField.backgroundColor = UIColor.textFieldColor
        majorTextField.layer.cornerRadius = 4
        majorTextField.placeholder = "전공 검색하기"
        majorTextField.addLeftPadding()
        majorTextField.font = .systemFont(ofSize: 15)
        majorTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        majorTextField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        majorTextField.addTarget(self, action: #selector(editingDidEnd(_:)), for: .editingDidEnd)
        majorTextField.textColor = .black
        return majorTextField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(majorTextField)
        
        helper.lineSpacing(titleLabel, 10) // lineSpacing
        
        titleLabel.snp.makeConstraints{(make) in
            make.topMargin.equalTo(56)
            make.leftMargin.equalTo(25)
//            make.height.equalTo(24)
        }
        
        majorTextField.snp.makeConstraints{(make) in
            make.topMargin.equalTo(titleLabel.snp.bottom).offset(40)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-125)
//            make.rightMargin.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-25)
            make.height.equalTo(60)
        }
        
    }
    
    @objc func textFieldDidChange(_ sender: Any){
        print(#function)
    }
    
    @objc func editingDidBegin(_ sender: Any){
        majorTextField.layer.borderWidth = 1
        majorTextField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @objc func editingDidEnd(_ sender: Any){
        majorTextField.layer.borderWidth = 1
        majorTextField.layer.borderColor = UIColor.white.cgColor
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
