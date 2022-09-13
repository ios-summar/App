//
//  LoginView.swift
//  Summar
//
//  Created by ukBook on 2022/09/12.
//

import Foundation
import UIKit


/// 로그인 화면
class LoginView : UIView{
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let emailTextField : UITextField = {
        let emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        return emailTextField
    }()
    
    let passwordTextField : UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        return passwordTextField
    }()
    
    let findBtn : UIButton = {
        let findBtn = UIButton()
        findBtn.translatesAutoresizingMaskIntoConstraints = false
        return findBtn
    }()
    
    let loginBtn : UIButton = {
        let loginBtn = UIButton()
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        return loginBtn
    }()
    
    let registerLabel : UILabel = {
        let registerLabel = UILabel()
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        return registerLabel
    }()
    
    let registerBtn : UIButton = {
        let registerBtn = UIButton()
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        return registerBtn
    }()
    
    let viewLine : UIView = {
        let viewLine = UIView()
        viewLine.translatesAutoresizingMaskIntoConstraints = false
        return viewLine
    }()
    
    let loginLabel : UILabel = {
        let loginLabel = UILabel()
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginLabel
    }()
    
    let socialLoginBtn1 : UIButton = {
        let socialLoginBtn1 = UIButton()
        socialLoginBtn1.translatesAutoresizingMaskIntoConstraints = false
        return socialLoginBtn1
    }()
    
    let socialLoginBtn2 : UIButton = {
        let socialLoginBtn2 = UIButton()
        socialLoginBtn2.translatesAutoresizingMaskIntoConstraints = false
        return socialLoginBtn2
    }()
    
    let socialLoginBtn3 : UIButton = {
        let socialLoginBtn3 = UIButton()
        socialLoginBtn3.translatesAutoresizingMaskIntoConstraints = false
        return socialLoginBtn3
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        
        addSubview(findBtn)
        addSubview(loginBtn)
        addSubview(registerLabel)
//        addSubview(registerBtn)
        
        addSubview(viewLine)
        addSubview(loginLabel)
        
        addSubview(socialLoginBtn1)
        addSubview(socialLoginBtn2)
        addSubview(socialLoginBtn3)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.backgroundColor = UIColor.blue
        
        titleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 30).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        titleLabel.text = "손쉽게 써머에 합류하기"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        //204 205 210 border color
        emailTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.keyboardType = .emailAddress
        emailTextField.placeholder = "이메일 주소" // placeholder
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderColor = CGColor(red: 204/255, green: 205/255, blue: 210/255, alpha: 1)
        emailTextField.addLeftPadding() // leftPadding 추가
        
        passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.isSecureTextEntry = true // 비밀번호가 화면에 노출되지 않게
        passwordTextField.placeholder = "비밀번호" // placeholder
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderColor = CGColor(red: 204/255, green: 205/255, blue: 210/255, alpha: 1)
        passwordTextField.addLeftPadding() // leftPadding 추가
        
        findBtn.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 10).isActive = true
        findBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        findBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        findBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        findBtn.setTitle("비밀번호를 잊어버리셨나요?", for: .normal)
        findBtn.setTitleColor(.systemBlue, for: .normal)
        findBtn.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        findBtn.tag = 0
        
        loginBtn.topAnchor.constraint(equalTo: self.findBtn.bottomAnchor, constant: 20).isActive = true
        loginBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        loginBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        loginBtn.setTitle("로그인", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.backgroundColor = UIColor.systemBlue
        loginBtn.layer.cornerRadius = 10
        loginBtn.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        loginBtn.tag = 1
        
        registerLabel.topAnchor.constraint(equalTo: self.loginBtn.bottomAnchor, constant: 17.5).isActive = true
        registerLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        registerLabel.font = registerLabel.font.withSize(15)
        registerLabel.textColor = UIColor.systemGray
        registerLabel.text = "아직도 써머의 회원이 아니신가요? 회원가입"
        let attributedStr = NSMutableAttributedString(string: registerLabel.text!)
        attributedStr.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: (registerLabel.text! as NSString).range(of: "회원가입"))
        attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 15), range: (registerLabel.text! as NSString).range(of: "회원가입"))
        registerLabel.attributedText = attributedStr
        
        registerLabel.tag = 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.btnAction(_:)))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(tap)
        
        
        viewLine.backgroundColor = UIColor.systemGray5
        viewLine.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 30).isActive = true
        viewLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        viewLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        viewLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        loginLabel.topAnchor.constraint(equalTo: self.viewLine.bottomAnchor, constant: 17.5).isActive = true
        loginLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        loginLabel.font = loginLabel.font.withSize(15)
        loginLabel.textColor = UIColor.systemGray
        loginLabel.text = "또는 아래 방법으로 쉽게 로그인하기"
        
        socialLoginBtn2.backgroundColor = UIColor.black
        socialLoginBtn2.topAnchor.constraint(equalTo: self.loginLabel.bottomAnchor, constant: 20).isActive = true
        socialLoginBtn2.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        socialLoginBtn2.widthAnchor.constraint(equalToConstant: 50).isActive = true
        socialLoginBtn2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        socialLoginBtn2.layer.cornerRadius = 25
        socialLoginBtn2.tag = 4
        socialLoginBtn2.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        
        socialLoginBtn1.backgroundColor = UIColor(red: 218/255, green: 69/255, blue: 72/255, alpha: 1)
        socialLoginBtn1.topAnchor.constraint(equalTo: self.loginLabel.bottomAnchor, constant: 20).isActive = true
        socialLoginBtn1.rightAnchor.constraint(equalTo: self.socialLoginBtn2.leftAnchor, constant: -20).isActive = true
        socialLoginBtn1.widthAnchor.constraint(equalToConstant: 50).isActive = true
        socialLoginBtn1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        socialLoginBtn1.layer.cornerRadius = 25
        socialLoginBtn1.tag = 3
        socialLoginBtn1.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        
        socialLoginBtn3.backgroundColor = UIColor.systemBlue
        socialLoginBtn3.topAnchor.constraint(equalTo: self.loginLabel.bottomAnchor, constant: 20).isActive = true
        socialLoginBtn3.leftAnchor.constraint(equalTo: self.socialLoginBtn2.rightAnchor, constant: 20).isActive = true
        socialLoginBtn3.widthAnchor.constraint(equalToConstant: 50).isActive = true
        socialLoginBtn3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        socialLoginBtn3.layer.cornerRadius = 25
        socialLoginBtn3.tag = 5
        socialLoginBtn3.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
    }
    
    @objc func btnAction(_ sender: Any){
        if let tagIndex = (sender as AnyObject).tag { // 그외 로직
            switch tagIndex {
            case 0:
                print("비밀번호찾기")
            case 1:
                print("로그인")
            case 3:
                print("소셜로그인 구글")
            case 4:
                print("소셜로그인 애플")
            case 5:
                print("소셜로그인 페이스북")
            default:
                print("default")
            }
        }else { // 회원가입 로직
            print("회원가입 로직")
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
