//
//  LoginView.swift
//  Summar
//
//  Created by ukBook on 2022/10/16.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import AuthenticationServices // 애플 로그인 https://huisoo.tistory.com/3

/// 로그인 화면
class LoginView : UIView {
    
    let helper : Helper = Helper()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "SignUpImage")
        return imageView
    }()
    
    let emailTextField : UITextField = {
        let emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.keyboardType = .emailAddress
        emailTextField.placeholder = "아이디" // placeholder
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 4
        emailTextField.autocapitalizationType = .none
        emailTextField.layer.backgroundColor = CGColor(red: 244/255, green: 246/255, blue: 254/255, alpha: 1)
        emailTextField.layer.borderColor = CGColor(red: 244/255, green: 246/255, blue: 254/255, alpha: 1)
        emailTextField.addLeftPadding() // leftPadding 추가
        emailTextField.tag = 10
        return emailTextField
    }()
    
    let passwordTextField : UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true // 비밀번호가 화면에 노출되지 않게
        passwordTextField.placeholder = "비밀번호" // placeholder
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 4
        passwordTextField.layer.backgroundColor = CGColor(red: 244/255, green: 246/255, blue: 254/255, alpha: 1)
        passwordTextField.layer.borderColor = CGColor(red: 244/255, green: 246/255, blue: 254/255, alpha: 1)
        passwordTextField.addLeftPadding() // leftPadding 추가
        passwordTextField.tag = 11
        return passwordTextField
    }()
    
    let findBtn : UIButton = {
        let findBtn = UIButton()
        findBtn.translatesAutoresizingMaskIntoConstraints = false
        findBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        findBtn.setTitle("아이디 찾기", for: .normal)
        findBtn.setTitleColor(UIColor.summarColor1, for: .normal)
        findBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        findBtn.tag = 0
        return findBtn
    }()
    
    let findBtn2 : UIButton = {
        let findBtn2 = UIButton()
        findBtn2.translatesAutoresizingMaskIntoConstraints = false
        findBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        findBtn2.setTitle("비밀번호 찾기", for: .normal)
        findBtn2.setTitleColor(UIColor.summarColor1, for: .normal)
        findBtn2.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        findBtn2.tag = 1
        return findBtn2
    }()
    
    let loginBtn : UIButton = {
        let loginBtn = UIButton()
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.setTitle("로그인", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = .systemFont(ofSize: 18)
        loginBtn.backgroundColor = .systemGray
        loginBtn.layer.cornerRadius = 5
        loginBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        loginBtn.tag = 2
        loginBtn.isEnabled = false
        return loginBtn
    }()
    
    let registerLabel : UILabel = {
        let registerLabel = UILabel()
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        registerLabel.text = "Summar의 회원이 되세요!"
        registerLabel.font = UIFont.systemFont(ofSize: 13)
        return registerLabel
    }()
    
    let viewLine : UIView = {
        let viewLine = UIView()
        viewLine.translatesAutoresizingMaskIntoConstraints = false
        viewLine.backgroundColor = UIColor(displayP3Red: 197/255, green: 197/255, blue: 197/255, alpha: 1)
        return viewLine
    }()
    
    
    let registerBtn : UIButton = {
        let registerBtn = UIButton()
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        registerBtn.backgroundColor = UIColor.summarColor2
        registerBtn.layer.cornerRadius = 4
        registerBtn.setTitle("회원가입", for: .normal)
        registerBtn.setTitleColor(UIColor.white, for: .normal)
        registerBtn.tag = 3
        registerBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        return registerBtn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        addSubview(imageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        
        addSubview(findBtn)
        addSubview(viewLine)
        addSubview(findBtn2)
        
        addSubview(loginBtn)
        addSubview(registerLabel)
        
        addSubview(registerBtn)
        
        
        imageView.snp.makeConstraints {(make) in
            make.topMargin.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(166)
        }
        
        emailTextField.snp.makeConstraints{(make) in
            make.topMargin.equalTo(imageView.snp.bottom).offset(60)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
        
        
        passwordTextField.snp.makeConstraints{(make) in
            make.topMargin.equalTo(emailTextField.snp.bottom).offset(20)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
        
        loginBtn.snp.makeConstraints{(make) in
            make.topMargin.equalTo(passwordTextField.snp.bottom).offset(28)
            make.rightMargin.equalTo(-25)
            make.width.equalTo(100)
            make.height.equalTo(52)
        }
        
        findBtn.snp.makeConstraints{(make) in
            make.centerY.equalTo(self.loginBtn)
            make.leftMargin.equalTo(25)
            make.height.equalTo(30)
        }
        
        
        viewLine.snp.makeConstraints{(make) in
            make.centerY.equalTo(loginBtn)
            make.leftMargin.equalTo(findBtn.snp.right).offset(18)
            make.height.equalTo(15)
            make.width.equalTo(1)
        }
        
        
        findBtn2.snp.makeConstraints{(make) in
            make.centerY.equalTo(self.loginBtn)
            make.leftMargin.equalTo(viewLine.snp.right).offset(18)
            make.height.equalTo(30)
        }
        
        
        registerLabel.snp.makeConstraints{(make) in
            make.topMargin.equalTo(findBtn.snp.bottom).offset(100)
            make.leftMargin.equalTo(25)
        }
        

        registerBtn.snp.makeConstraints{(make) in
            make.topMargin.equalTo(registerLabel.snp.bottom).offset(15)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
    }
    
    @objc func btnAction(_ sender: Any){
        if let tagIndex = (sender as AnyObject).tag { // 그외 로직
            switch tagIndex {
            case 0:
                print("아이디 찾기")
            case 1:
                print("비밀번호 찾기")
            case 2:
                print("로그인")
                loginAction()
            case 3:
                print("회원가입")
            default:
                print("default")
            }
        }else { // 회원가입 로직
            print("회원가입 로직")
            
        }
    }
    
    func loginAction(){
        var id = emailTextField.text!
        var password = passwordTextField.text!
        
        if id.isEmpty { // 아이디 빈칸체크
            helper.showAlert(vc: self, message: "아이디를 입력해주세요.")
        }else if password.isEmpty { // 비밀번호 빈칸체크
            helper.showAlert(vc: self, message: "비밀번호를 입력해주세요.")
        }else { // 빈칸은 아님
            // 서버통신이후 유효한 아이디/비밀번호인지 체크후 다음화면으로
            serverLogin(id: id, password: password)
        }
    }
    
    func serverLogin(id: String, password: String) {
        print(#function)
        print(id)
        print(password)
        let url = "http://13.209.114.45:8080/api/v1/login"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "accept")
        request.setValue("utf-8", forHTTPHeaderField: "Accept-Charset")
    
        request.timeoutInterval = 10
        
        let params = [
            "username": id,
            "password": password
        ] as Dictionary

//         httpBody 에 parameters 추가
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success:
                print("POST 성공")
                print(response)
                do {
                    let dicCreate = try JSONSerialization.jsonObject(with: Data(response.data!), options: []) as! NSDictionary // [jsonArray In jsonObject 형식 데이터를 파싱 실시 : 유니코드 형식 문자열이 자동으로 변환됨]
////                    print(dicCreate)
//                    self.dataParsing(dicCreate: dicCreate)
//                    print(type(of: response))
//                    print(dicCreate)
                    
                    print(dicCreate["accessToken"]!)
                    print(dicCreate["refreshToken"]!)
                    
                    
                } catch {
                    print("catch :: ", error.localizedDescription)
                }
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    func dataParsing(dicCreate : NSArray){
        for i in 0...dicCreate.count - 1 {
            let firstResult = dicCreate[i]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: firstResult, options: JSONSerialization.WritingOptions.prettyPrinted)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                
                if let jsonN = json {
                    print(jsonN)
                }else {
                    print("nil")
                }
            } catch{
                print(error)
            }
            
        }
    }
    
    @objc
    /// 아이디 / 비밀번호의 빈칸을 체크해 isEnable값 변경
    /// - Parameter textField: ID / PW
    func textFieldDidChange (_ textField : UITextField){
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            disableBtn(yn: false)
        }else {
            disableBtn(yn: true)
        }
    }
    
    func disableBtn(yn : Bool) {
        if yn { // 사용할 수 있음
            loginBtn.backgroundColor = UIColor.summarColor2
            loginBtn.isEnabled = true
        }else { // 사용할 수 없음
            loginBtn.backgroundColor = .systemGray
            loginBtn.isEnabled = false
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

