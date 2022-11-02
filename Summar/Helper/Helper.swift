//
//  Helper.swift
//  Summar
//
//  Created by ukBook on 2022/09/13.
//

import Foundation
import UIKit

class Helper : UIView{
    func showAlert(vc: UIView?, preferredStyle: UIAlertController.Style = .alert, title: String = "알림", message: String = "", completTitle: String = "확인") {
        guard let currentVc = vc else {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: completTitle, style: .default, handler: nil))
        vc?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showAlertAction(vc: UIViewController?, preferredStyle: UIAlertController.Style = .alert, title: String = "", message: String = "", completeTitle: String = "확인", _ completeHandler:(() -> Void)? = nil){
                
                guard let currentVc = vc else {
                    completeHandler?()
                    return
                }
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
                    
                    let completeAction = UIAlertAction(title: completeTitle, style: .default) { action in
                        completeHandler?()
                        if message == "네트워크 연결 상태를 확인해주세요."{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                exit(0)
                            }
                        }
                    }
                    
                    alert.addAction(completeAction)
                    
                    currentVc.present(alert, animated: true, completion: nil)
                }
    }
    
    func checkNickNamePolicy(text: String) -> Bool {
        // String -> Array
        let arr = Array(text)
        // 정규식 pattern. 한글, 영어, 숫자만 있어야함
        let pattern = "^[가-힣a-zA-Z0-9]$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            var index = 0
            while index < arr.count { // string 내 각 문자 하나하나 마다 정규식 체크 후 충족하지 못한것은 제거.
                let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
                if results.count == 0 {
                    return false
                } else {
                    index += 1
                }
            }
        }
        return true
    }
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}

extension UIColor {
    static var summarColor1 = UIColor.init(red: 31/255, green: 65/255, blue: 185/255, alpha: 1)
    static var summarColor2 = UIColor.init(red: 53/255, green: 97/255, blue: 254/255, alpha: 1)
    static var kakaoColor = UIColor.init(red: 250/255, green: 227/255, blue: 0/255, alpha: 1)
    static var appleColor = UIColor.init(red: 52/255, green: 52/255, blue: 52/255, alpha: 1)
    static var naverColor = UIColor.init(red: 45/255, green: 180/255, blue: 0/255, alpha: 1)
    static var googleColor = UIColor.init(red: 245/255, green: 86/255, blue: 73/255, alpha: 1)
    static var grayColor245 = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    static var grayColor205 = UIColor.init(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
    static var grayColor197 = UIColor.init(red: 197/255, green: 197/255, blue: 197/255, alpha: 1)
    static var textFieldColor = UIColor.init(red: 243/255, green: 246/255, blue: 255/255, alpha: 1)
}

extension String {
    
    // 핸드폰 번호 정규성 체크
    func validatePhoneNumber(_ input: String) -> Bool {

        let regex = "^01[0-1, 7][0-9]{7,8}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = phonePredicate.evaluate(with: input)

        print("isValid", String())
        if isValid {
            return true
        } else {
            return false
        }
    }

    // 이메일 정규성 체크
    func validateEmail(_ input: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = emailPredicate.evaluate(with: input)

        if isValid {
            return true
        } else {
            return false
        }
    }

    // 패스워드 정규성 체크
    func validatePassword(_ input: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}" // 8자리 ~ 50자리 영어+숫자+특수문자

        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: input)

        if isValid {
            return true
        } else {
            return false
        }
    }
    
    func hasCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ`~!@#$%^&*()\\-_=+\\[{\\]}\\\\|;:'\",<.>/?\\s]$", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
        }catch {
            return false
        }
        return false
    }

    
    // 문자열 자르기
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
}
