//
//  SocialLoginController.swift
//  Summar
//
//  Created by mac on 2022/10/18.
//

import Foundation
import UIKit
import SnapKit

final class SocialLoginController : UIViewController, SocialLoginDelegate {
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
        if VC.isKind(of: SignUpController.self) {
            let VC = SignUpController()
            
            VC.requestDic = requestDic
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC.isKind(of: HomeController.self) {
            let VC = HomeController()
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(VC, animated: false)
        }
    }
}
