//
//  Helper.swift
//  Summar
//
//  Created by ukBook on 2022/09/13.
//

import Foundation
import UIKit
import AVFoundation

final class Helper : UIView{
    static let shared = Helper()
    func showAlert(vc: UIView?, preferredStyle: UIAlertController.Style = .alert, title: String = "알림", message: String = "", completTitle: String = "확인") {
        guard let currentVc = vc else {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: completTitle, style: .default, handler: nil))
        vc?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showAlert2(vc: UIView?, preferredStyle: UIAlertController.Style = .alert, title: String = "알림", message: String = "", completTitle: String = "확인", cancleTitle: String = "취소", completion: @escaping (Bool) -> ()) {
        guard let currentVc = vc else {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let completAction = UIAlertAction(title: completTitle, style: .default) { action in
            completion(true)
        }
        alert.addAction(UIAlertAction(title: cancleTitle, style: .cancel, handler: nil))
        
        alert.addAction(completAction)
        vc?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    /// UIView Alert 그냥 확인
    func showAlertActionNormal(vc: UIView?, preferredStyle: UIAlertController.Style = .alert, title: String = "알림", message: String = "", completTitle: String = "확인", completion: @escaping (Bool) -> ()) {
        guard let currentVc = vc else {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let completAction = UIAlertAction(title: completTitle, style: .default) { action in
            completion(true)
        }
        alert.addAction(completAction)
        vc?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    /// UIViewController Alert 확인, 취소
    func showAlertActionYN(vc: UIViewController?, preferredStyle: UIAlertController.Style = .alert, title: String = "알림", message: String = "", completTitle: String = "확인", cancleTitle: String = "취소", completion: @escaping (Bool?) -> ()) {
        guard let currentVc = vc else {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let completAction = UIAlertAction(title: completTitle, style: .default) { action in
            completion(true)
        }
        let cancleAction = UIAlertAction(title: cancleTitle, style: .cancel) { action in
            completion(nil)
        }
        
        alert.addAction(completAction)
        alert.addAction(cancleAction)
        currentVc.present(alert, animated: true, completion: nil)
    }
    
    /// UIViewController Alert 기본
    func showAlertAction(vc: UIViewController?, preferredStyle: UIAlertController.Style = .alert, title: String = "알림", message: String = "", completeTitle: String = "확인", _ completeHandler:(() -> Void)? = nil){
                
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
    
    /// 액션시트 2,1
    func showAlertAction(vc: UIViewController?, preferredStyle: UIAlertController.Style = .actionSheet, message1: String = "", message2: String = "", cancel: String = "닫기", completeHandler:((String) -> Void)? = nil){
                
                guard let currentVc = vc else {
                    completeHandler?("")
                    return
                }
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: preferredStyle)
                    
                    let action1 = UIAlertAction(title: message1, style: .default) { action in
                        completeHandler?(message1)
                    }
                    
                    let action2 = UIAlertAction(title: message2, style: .default) { action in
                        completeHandler?(message2)
                    }
                    
                    let cancelAction = UIAlertAction(title: cancel, style: .cancel) { action in
                        completeHandler?(cancel)
                    }
                    
                    alert.addAction(action1)
                    alert.addAction(action2)
                    alert.addAction(cancelAction)
                    
                    currentVc.present(alert, animated: true, completion: nil)
                }
    }
    
    /// 액션시트 1,1
    func showAlertAction(vc: UIViewController?, preferredStyle: UIAlertController.Style = .actionSheet, message: String = "", cancel: String = "닫기", completeHandler:((String) -> Void)? = nil){
                
                guard let currentVc = vc else {
                    completeHandler?("")
                    return
                }
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: preferredStyle)
                    
                    let action1 = UIAlertAction(title: message, style: .destructive) { action in
                        completeHandler?(message)
                    }
                    
                    let cancelAction = UIAlertAction(title: cancel, style: .cancel) { action in
                        completeHandler?(cancel)
                    }
                    
                    alert.addAction(action1)
                    alert.addAction(cancelAction)
                    
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
    
    func lineSpacing(_ uiLabel: UILabel, _ lineCF: CGFloat){
        let attrString = NSMutableAttributedString(string: uiLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineCF
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        uiLabel.attributedText = attrString
        uiLabel.lineBreakMode = .byTruncatingTail
    }
    
    // MARK: - 앱버전 체크 https://kirinit.tistory.com/10
//    static func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
//        guard let info = Bundle.main.infoDictionary,
//            let currentVersion = info["CFBundleShortVersionString"] as? String, // 현재 버전 가져오기
//            let identifier = info["CFBundleIdentifier"] as? String, // 앱 번들아이디 가져오기
//            let url = URL(string: "http://itundes.apple.com/kr/lookup?bundleId=\(identifier)") else {
//                throw VersionError.invalidBundleInfo
//            }
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            do {
//                if let error = error { throw error }
//                guard let data = data else { throw VersionError.invalidResponse }
//                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
//                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
//                    throw VersionError.invalidResponse
//                } // 앱스토어 버전 가져오기
//                let verFloat = NSString.init(string: version).floatValue
//                let currentVerFloat = NSString.init(string: currentVersion).floatValue
//                completion(verFloat > currentVerFloat, nil) // 현재 버전이 앱스토어 버전보다 큰지를 Bool 값으로 반환
//            } catch {
//                completion(nil, error)
//            }
//        }
//        task.resume()
//        return task
//    }
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    //Launch Screen Color
    static var launchScreenBackGroundColor = UIColor.init(red: 19/255, green: 120/255, blue: 224/255, alpha: 1)
    
    //Main Color
    static var summarColor1 = UIColor.init(red: 31/255, green: 65/255, blue: 185/255, alpha: 1)
    static var summarColor2 = UIColor.init(red: 53/255, green: 97/255, blue: 254/255, alpha: 1)
    
    //Social Login COlor
    static var kakaoColor = UIColor.init(red: 250/255, green: 227/255, blue: 0/255, alpha: 1)
    static var appleColor = UIColor.init(red: 52/255, green: 52/255, blue: 52/255, alpha: 1)
    static var naverColor = UIColor.init(red: 45/255, green: 180/255, blue: 0/255, alpha: 1)
    static var googleColor = UIColor.init(red: 245/255, green: 86/255, blue: 73/255, alpha: 1)
    
    //Gray Color
    static var grayColor245 = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    static var grayColor205 = UIColor.init(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
    static var grayColor197 = UIColor.init(red: 197/255, green: 197/255, blue: 197/255, alpha: 1)
    static var textFieldColor = UIColor.init(red: 243/255, green: 246/255, blue: 255/255, alpha: 1)
    
    //HomeController
    static var homeTitleColor = UIColor.init(red: 44/255, green: 80/255, blue: 206/255, alpha: 1)
    static var homeViewColor = UIColor.init(red: 242/255, green: 243/255, blue: 248/255, alpha: 1)
    static var UIBarColor = UIColor.init(red: 240/255, green: 242/255, blue: 246/255, alpha: 1)
    
    //1TabbarHome
    static var homeContentsColor = UIColor.init(r: 79, g: 79, b: 79)
    //2TabbarClipping

    //3TabbarFeed
    static var fontColor = UIColor.init(red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
    static var magnifyingGlassColor = UIColor.init(red: 51/255, green: 102/255, blue: 255/255, alpha: 1)
    //4TabbarSearch
    static var searchGray = UIColor.init(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)
    static var imageViewColor = UIColor.init(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
    static var fontGrayColor = UIColor(red: 158/255, green: 164/255, blue: 170/255, alpha: 1)
    
    //5TabbarMyInfo
    static var BackgroundColor = UIColor.init(red: 251/255, green: 251/255, blue: 253/255, alpha: 1)
    static var followShadowColor = UIColor.init(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)

    //프로필 편집
    static var RedSeven = UIColor.init(r: 183, g: 21, b: 35)
    static var GreenOne = UIColor.init(r: 58, g: 228, b: 96)
    
    //설정
    static var Gray01 = UIColor.init(red: 247/255, green: 248/255, blue: 249/255, alpha: 1)
    static var Gray02 = UIColor.init(r: 232, g: 235, b: 237)
    
    static var updateColor = UIColor.init(r: 255, g: 121, b: 96)
    
    //Text Color
    static var textColor115 = UIColor.init(r: 115, g: 120, b: 127)
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

extension Int {
    private static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    var commaRepresentation: String {
        if self >= 10000 {
            var foramtter : Int = self / 1000
            return "\(CFloat(CGFloat(foramtter) / 10.0)) 만"
        }else {
            return Int.commaFormatter.string(from: NSNumber(value: self)) ?? ""
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension UINavigationItem {
    //  UINavigationItem+Extensions.swift
    func makeSFSymbolButton(_ target: Any?, action: Selector, uiImage: UIImage, tintColor : UIColor) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(uiImage, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = tintColor
            
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
        return barButtonItem
    }
    
    func makeSFSymbolButtonWidth30(_ target: Any?, action: Selector, uiImage: UIImage, tintColor : UIColor) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(uiImage, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = tintColor
            
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
            
        return barButtonItem
    }
    
    func makeSFSymbolButtonLabel(_ target: Any?, action: Selector, title: String, tintColor : UIColor) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = tintColor
            
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
        return barButtonItem
    }
}

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}

extension UIScrollView {
    func updateContentSize() {
        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
        
        // 계산된 크기로 컨텐츠 사이즈 설정
        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height)
    }
    
    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect: CGRect = .zero
        
        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
        for subView in view.subviews {
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }
        
        // 최종 계산 영역의 크기를 반환
        return totalRect.union(view.frame)
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(1519)
    }
}
