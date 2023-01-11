//
//  SocialLoginController.swift
//  Summar
//
//  Created by mac on 2022/10/18.
//

import Foundation
import UIKit
import SnapKit

class SocialLoginController : UIViewController, SocialLoginDelegate {
    static let shared = SocialLoginController()
    let socialLoginView = SocialLoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(socialLoginView)
        socialLoginView.delegate = self
        
        // layout
        socialLoginView.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }

    // MARK: - DB에 회원 유무 확인후 화면 이동
    func pushScreen(_ VC: UIViewController, _ requestDic: Dictionary<String, Any>) {
        print(#file , #function)
        print(VC)
        
        print("self.navigationController \(self.navigationController)")
        if VC == SignUpController.shared {
            let svc = SignUpController.shared
            svc.requestDic = requestDic
            self.navigationController?.pushViewController(svc, animated: true)
        }else if VC == HomeController.shared {
            let svc = HomeController.shared
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(svc, animated: false)
        }
    }
}
