//
//  SignUp2View.swift
//  Summar
//
//  Created by mac on 2022/10/25.
//

import Foundation
import SnapKit

class SignUp2View : UIView, UITextFieldDelegate {
    
    let helper = Helper()
    
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "인증번호를 입력해 주세요"
        titleLabel.textColor = UIColor.summarColor1
        titleLabel.font = .boldSystemFont(ofSize: 20)
        return titleLabel
    }()
    
    let sendBtn : UIButton = {
        let sendBtn = UIButton()
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.setTitle("전송", for: .normal)
        sendBtn.setTitleColor(.black, for: .normal)
        sendBtn.titleLabel?.font = .systemFont(ofSize: 15)
        sendBtn.layer.borderWidth = 1
        sendBtn.layer.borderColor = UIColor.grayColor205.cgColor
        sendBtn.layer.cornerRadius = 4
        return sendBtn
    }()
    
    let cellPhoneTextField : UITextField = {
        let cellPhoneTextField = UITextField()
        cellPhoneTextField.translatesAutoresizingMaskIntoConstraints = false
        cellPhoneTextField.keyboardType = .numberPad
        cellPhoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cellPhoneTextField.layer.borderWidth = 1
        cellPhoneTextField.layer.borderColor = UIColor.grayColor205.cgColor
        cellPhoneTextField.layer.cornerRadius = 4
        cellPhoneTextField.placeholder = "휴대폰 번호"
        cellPhoneTextField.addLeftPadding()
        return cellPhoneTextField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(sendBtn)
        addSubview(cellPhoneTextField)
        
//        checkMaxLength(textField: cellPhoneTextField, maxLength: 11)

        titleLabel.snp.makeConstraints{(make) in
            make.topMargin.equalTo(56)
            make.leftMargin.equalTo(25)
            make.height.equalTo(24)
        }
        
        sendBtn.snp.makeConstraints{(make) in
            make.topMargin.equalTo(110)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
            make.width.equalTo(96)
        }
        
        cellPhoneTextField.snp.makeConstraints{(make) in
//            make.topMargin.equalTo(titleLabel).offset(50)
            make.centerY.equalTo(sendBtn.snp.centerY)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(sendBtn.snp.left).offset(-20)
            make.height.equalTo(52)
//            make.width.equalTo(220)
        }
    }
    

    @objc func textFieldDidChange(_ sender: Any) {
        if let textField = sender as? UITextField {
            if (textField.text?.count ?? 0 > 11) {
                textField.deleteBackward()
            }
        }
    }
    
    @objc func btnAction(_ sender: Any){
        print(sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
