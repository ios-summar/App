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
    
    func moveScreen(storyboard: String, controller: String) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: controller)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
