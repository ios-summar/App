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
    func nextBtn()
}

class SignUp1View : UIView, UITextFieldDelegate {
    
    weak var delegate: signUp1Delegate?
    
    let helper = Helper()
    let request = ServerRequest()
    
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
        
        // 키보드 팝업시 위 버튼 추가
        nickNameTextField.inputAccessoryView = accessoryView
        accessoryView.addSubview(keyboardUpBtn)
        
        helper.lineSpacing(titleLabel, 10) // lineSpacing
        
        keyboardUpBtn.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(-20)
            make.leftMargin.equalTo(0)
            make.rightMargin.equalTo(0)
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
        
//        sendBtn.snp.makeConstraints{(make) in
//            make.bottomMargin.equalTo(-20)
//            make.leftMargin.equalTo(25)
//            make.rightMargin.equalTo(-25)
//            make.height.equalTo(52)
//        }
    }
    
    @objc func nextAction(){
        self.delegate?.nextBtn()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if (textField.text?.count ?? 0 > 8) {
            textField.deleteBackward()
        }
        
        if textField.text?.count ?? 0 >= 2 {
            if helper.checkNickNamePolicy(text: textField.text!) { // 한글, 영어, 숫자임
                // GET방식으로 닉네임 중복체크
                requestGETBOOL(requestUrl: "/user/nicknameCheck/\(textField.text!)")
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
            self.delegate?.sendBtnEnable(true)
            self.sendBtnEnable(true)
            nickNameEnableLabel.text = content
            nickNameEnableLabel.textColor = .systemGreen
            nickNameTextField.layer.borderColor = UIColor.systemGreen.cgColor
        }else {
            self.delegate?.sendBtnEnable(false)
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
        // URL 객체 정의
//                let url = URL(string: serverURL()+requestUrl)
                let urlStr = self.serverURL()+requestUrl
                let encoded = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let myURL = URL(string: encoded!)
                // URLRequest 객체를 정의
                var request = URLRequest(url: myURL!)
                request.httpMethod = "GET"

                // HTTP 메시지 헤더
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    // 서버가 응답이 없거나 통신이 실패
                    if let e = error {
                        self.helper.showAlert(vc: self, message: "네트워크 상태를 확인해주세요.")
                    }

                    var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                    print(responseString!)
                    DispatchQueue.main.async {
                        if responseString! == "true"{ // 중복
                            self.enableNickname(enable: false, content: "중복된 닉네임입니다.")
                        }else {
                            self.enableNickname(enable: true, content: "사용 가능한 닉네임입니다.")
                        }
                    }
                }
                task.resume()
    }
    
    func sendBtnEnable(_ TF: Bool) {
        if TF {
            keyboardUpBtn.isEnabled = true
            keyboardUpBtn.backgroundColor = UIColor.summarColor2
        }else {
            keyboardUpBtn.isEnabled = false
            keyboardUpBtn.backgroundColor = UIColor.grayColor205
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
