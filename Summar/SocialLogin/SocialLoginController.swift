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
    
    let socialLoginView = SocialLoginView()
    let serverRequest = ServerRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(socialLoginView)
        
        socialLoginView.delegate = self
//        serverRequest.delegate = self
        
        // layout
        socialLoginView.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    func pushScreen(_ VC: UIViewController, _ identifier: String?) {
        
        if VC == SignUpController.shared {
            let svc = SignUpController.shared
            svc.identifier = identifier
            self.navigationController?.pushViewController(svc, animated: true)
        }else if VC == HomeController() { // 싱글톤 객체로 변경예정
            let svc = HomeController()
            self.navigationController?.pushViewController(svc, animated: true)
        }
    }
}
