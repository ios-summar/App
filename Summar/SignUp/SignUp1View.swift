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

protocol SignUp1Delegate : class {
    func nextBtn(_ nickName: String)
}

class SignUp1View : UIView, UITextFieldDelegate {
    static let shared = SignUp1View()
    
    weak var delegate: SignUp1Delegate?
    
    let helper = Helper()
//    let request = ServerRequest()
    
    let serverURL = { () -> String in
        let url = Bundle.main.url(forResource: "Network", withExtension: "plist")
        let dictionary = NSDictionary(contentsOf: url!)

        // 각 데이터 형에 맞도록 캐스팅 해줍니다.
        #if DEBUG
        var LocalURL = dictionary!["DebugURL"] as? String
        #elseif RELEASE
        var LocalURL = dictionary!["ReleaseURL"] as? String
        #endif
        
        return LocalURL!
    }
    
    var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 72.0))
    }()
    
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.text = "써머에서 이용할\n닉네임을 정해주세요"
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.summarColor1
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.sizeToFit()
        return titleLabel
    }()
    
    let nickNameTextField : UITextField = {
        let nickNameTextField = UITextField()
        nickNameTextField.translatesAutoresizingMaskIntoConstraints = false
        nickNameTextField.layer.borderWidth = 1
        nickNameTextField.layer.borderColor = UIColor.white.cgColor
        nickNameTextField.backgroundColor = UIColor.textFieldColor
        nickNameTextField.layer.cornerRadius = 4
        nickNameTextField.placeholder = "영문 또는 한글 2~8자"
        nickNameTextField.attributedPlaceholder = NSAttributedString(string: "영문 또는 한글 2~8자", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor205])
        nickNameTextField.addLeftPadding()
        nickNameTextField.font = .systemFont(ofSize: 15)
        nickNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nickNameTextField.textColor = .black
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
        sendBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
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
    
    let keyboardUpBtn : UIButton = {
        let keyboardUpBtn = UIButton()
        keyboardUpBtn.translatesAutoresizingMaskIntoConstraints = false
        keyboardUpBtn.setTitle("다음", for: .normal)
        keyboardUpBtn.setTitleColor(.white, for: .normal)
        keyboardUpBtn.titleLabel?.font = .systemFont(ofSize: 15)
        keyboardUpBtn.backgroundColor = UIColor.grayColor205
        keyboardUpBtn.layer.cornerRadius = 4
        keyboardUpBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return keyboardUpBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(nickNameTextField)
        addSubview(nickNameEnableLabel)
        addSubview(sendBtn)
        
        // 키보드 팝업시 위 버튼 추가
        nickNameTextField.inputAccessoryView = accessoryView
        accessoryView.addSubview(keyboardUpBtn)
        
        helper.lineSpacing(titleLabel, 10) // lineSpacing
        
        keyboardUpBtn.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(-25)
            make.leftMargin.equalTo(20)
            make.rightMargin.equalTo(-20)
            make.height.equalTo(52)
        }

        titleLabel.snp.makeConstraints{(make) in
            make.topMargin.equalTo(30)
            make.leftMargin.equalTo(25)
//            make.height.equalTo(24)
        }
        
        nickNameTextField.snp.makeConstraints{(make) in
            make.topMargin.equalTo(titleLabel.snp.bottom).offset(40)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(60)
        }
        
        nickNameEnableLabel.snp.makeConstraints{(make) in
            make.topMargin.equalTo(nickNameTextField.snp.bottom).offset(15)
            make.leftMargin.equalTo(30)
        }
        
        sendBtn.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(-25)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
        }
    }
    
    @objc func nextAction(){
        self.delegate?.nextBtn(nickNameTextField.text!)
        
        // 초기화
        nickNameTextField.text = ""
        keyboardUpBtn.isEnabled = false
        keyboardUpBtn.backgroundColor = UIColor.grayColor205
        
        sendBtn.isEnabled = false
        sendBtn.backgroundColor = UIColor.grayColor205
        
        nickNameEnableLabel.text = ""
        nickNameEnableLabel.textColor = .white
        nickNameTextField.layer.borderColor = UIColor.white.cgColor

    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if (textField.text?.count ?? 0 > 8) {
            textField.deleteBackward()
        }
        
        if textField.text?.count ?? 0 >= 1 {
            if helper.checkNickNamePolicy(text: textField.text!) { // 한글, 영어, 숫자임
                // GET방식으로 닉네임 중복체크
                requestGETBOOL(requestUrl: "/user/nickname-check?nickname=\(textField.text!)")
            }else { // 한글, 영어, 숫자가 아님.
                enableNickname(enable: false, content: "닉네임은 한글, 영어, 숫자만 사용 가능합니다.")
            }
        }else {
            if textField.text?.count ?? 0 == 0 {
                enableNickname(enable: false, content: nil)
            }else {
                enableNickname(enable: false, content: "닉네임을 두글자 이상 입력해주세요.")
            }
        }
    }
    
    func enableNickname(enable: Bool, content: String?){
        if enable {
            self.sendBtnEnable(true)
            nickNameEnableLabel.text = content
            nickNameEnableLabel.textColor = .systemGreen
            nickNameTextField.layer.borderColor = UIColor.systemGreen.cgColor
        }else {
            self.sendBtnEnable(false)
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
    }
    
    func requestGETBOOL(requestUrl : String!){
        let url = serverURL() + requestUrl
        let encodedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request = URLRequest(url: URL(string: encodedString)!)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        AF.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = value as! Dictionary<String, Any>
                let resultJson = json["result"] as! Dictionary<String, Any>
                
                let result = resultJson["result"]
                
                DispatchQueue.main.async {
                    if result as! Int == 1{ // 중복
                        self.enableNickname(enable: false, content: "중복된 닉네임입니다.")
                    }else {
                        self.enableNickname(enable: true, content: "사용 가능한 닉네임입니다.")
                    }
                }
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    func sendBtnEnable(_ TF: Bool) {
        if TF {
            keyboardUpBtn.isEnabled = true
            keyboardUpBtn.backgroundColor = UIColor.summarColor2
            
            sendBtn.isEnabled = true
            sendBtn.backgroundColor = UIColor.summarColor2
        }else {
            keyboardUpBtn.isEnabled = false
            keyboardUpBtn.backgroundColor = UIColor.grayColor205
            
            sendBtn.isEnabled = false
            sendBtn.backgroundColor = UIColor.grayColor205
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
