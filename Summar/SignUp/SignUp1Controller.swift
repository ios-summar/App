//
//  SignUp1Controller.swift
//  Summar
//
//  Created by ukBook on 2022/10/23.
//

import Foundation
import UIKit

class SignUp1Controller : UIViewController {
    
    let signUp1View = SignUp1View()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(signUp1View)
        
        // layout
        signUp1View.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
}
