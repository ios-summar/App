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
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}

extension UIColor {
    static var summarFontColor1 = UIColor.init(red: 31/255, green: 65/255, blue: 185/255, alpha: 1)
    static var summarFontColor2 = UIColor.init(red: 53/255, green: 97/255, blue: 254/255, alpha: 1)
}
