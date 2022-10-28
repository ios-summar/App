//
//  SignUp1View.swift
//  Summar
//
//  Created by ukBook on 2022/10/23.
//

import Foundation
import UIKit
import SnapKit

protocol signUp1Delegate : class {
    func moveSignUp2()
}

class SignUp1View : UIView, UITextFieldDelegate {
    
    weak var delegate: signUp1Delegate?
    
    let helper = Helper()
    
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "써머에서 이용할 닉네임을 정해주세요"
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.summarColor1
        titleLabel.font = .boldSystemFont(ofSize: 20)
        return titleLabel
    }()
    
    let nickNameTextField : UITextField = {
        let nickNameTextField = UITextField()
        nickNameTextField.translatesAutoresizingMaskIntoConstraints = false
        nickNameTextField.keyboardType = .numberPad
//        nickNameTextField.layer.borderWidth = 1
//        nickNameTextField.layer.borderColor = UIColor.grayColor205.cgColor
        nickNameTextField.backgroundColor = UIColor.textFieldColor
        nickNameTextField.layer.cornerRadius = 4
        nickNameTextField.placeholder = "영문 또는 한글 2~8자"
        nickNameTextField.addLeftPadding()
        nickNameTextField.font = .systemFont(ofSize: 15)
        nickNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return nickNameTextField
    }()
    
    let sendBtn : UIButton = {
        let sendBtn = UIButton()
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.setTitle("다음", for: .normal)
        sendBtn.setTitleColor(.white, for: .normal)
        sendBtn.titleLabel?.font = .systemFont(ofSize: 15)
        sendBtn.backgroundColor = UIColor.grayColor205
        sendBtn.layer.cornerRadius = 4
        return sendBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(nickNameTextField)
        addSubview(sendBtn)
        

        titleLabel.snp.makeConstraints{(make) in
            make.topMargin.equalTo(30)
            make.leftMargin.equalTo(25)
            make.height.equalTo(24)
        }
        
        nickNameTextField.snp.makeConstraints{(make) in
            make.topMargin.equalTo(titleLabel.snp.bottom).offset(40)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
        
        sendBtn.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(-20)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if (textField.text?.count ?? 0 > 8) {
            textField.deleteBackward()
        }
        
        if textField.text?.count ?? 0 >= 2 {
            print("a")
        }else {
            print("b")
        }
    }
    
    @objc func btnAction(_ sender : Any){
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
