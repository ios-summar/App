//
//  SignUp2Controller.swift
//  Summar
//
//  Created by mac on 2022/10/25.
//

import Foundation
import UIKit
import SnapKit

class SignUp2Controller : UIViewController {
    
    let signUp2View = SignUp2View()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(signUp2View)
        
        // layout
        signUp2View.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
}
