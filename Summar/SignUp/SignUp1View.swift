//
//  SignUp1View.swift
//  Summar
//
//  Created by ukBook on 2022/10/23.
//

import Foundation
import UIKit
import SnapKit
import Alamofire

protocol signUp1Delegate : class {
    func sendBtnEnable(_ TF: Bool)
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
        nickNameTextField.layer.borderWidth = 1
        nickNameTextField.layer.borderColor = UIColor.white.cgColor
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
    
    let nickNameEnableLabel : UILabel = {
        let nickNameEnableLabel = UILabel()
        nickNameEnableLabel.translatesAutoresizingMaskIntoConstraints = false
        nickNameEnableLabel.text = ""
        nickNameEnableLabel.textAlignment = .left
        nickNameEnableLabel.textColor = .white
        nickNameEnableLabel.font = .systemFont(ofSize: 14)
        nickNameEnableLabel.sizeToFit()
        return nickNameEnableLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(nickNameTextField)
        addSubview(nickNameEnableLabel)
        

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
        
        nickNameEnableLabel.snp.makeConstraints{(make) in
            make.topMargin.equalTo(nickNameTextField.snp.bottom).offset(15)
            make.leftMargin.equalTo(30)
        }
        
//        sendBtn.snp.makeConstraints{(make) in
//            make.bottomMargin.equalTo(-20)
//            make.leftMargin.equalTo(25)
//            make.rightMargin.equalTo(-25)
//            make.height.equalTo(52)
//        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if (textField.text?.count ?? 0 > 8) {
            textField.deleteBackward()
        }
        
        if textField.text?.count ?? 0 >= 2 {
            self.delegate?.sendBtnEnable(true)
        }else {
            if textField.text?.count ?? 0 == 0 {
                disableNickname(content: nil)
            }else {
                disableNickname(content: "닉네임을 두글자 이상 입력해주세요.")
            }
        }
    }
    
    func disableNickname(content: String?){
        self.delegate?.sendBtnEnable(false)
        
        if content != nil {
            nickNameEnableLabel.text = content
            nickNameEnableLabel.textColor = .systemRed
            nickNameTextField.layer.borderColor = UIColor.systemRed.cgColor
        }else {
            nickNameEnableLabel.text = ""
            nickNameEnableLabel.textColor = .white
            nickNameTextField.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func overlapNickname(nickName: String) {
        print(nickName)
        let url = "http://13.209.114.45:8080/api/v1/user/nicknameCheck/\(nickName)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "accept")
        request.setValue("utf-8", forHTTPHeaderField: "Accept-Charset")
    
        request.timeoutInterval = 10
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success:
                print("GET 성공")
                print(response)
                do {
                    
                } catch {
                    print("catch :: ", error.localizedDescription)
                }
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
