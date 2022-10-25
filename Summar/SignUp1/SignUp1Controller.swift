//
//  SignUp1Controller.swift
//  Summar
//
//  Created by ukBook on 2022/10/23.
//

import Foundation
import UIKit

class SignUp1Controller : UIViewController, PushViewDelegate {
    func pushView(storyboard: String, controller: String) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: controller)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    let signUp1View = SignUp1View()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signUp1View)
        
        signUp1View.delegate = self
        
        // layout
        signUp1View.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
 }
