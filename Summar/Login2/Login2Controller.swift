//
//  Login2Controller.swift
//  Summar
//
//  Created by ukBook on 2022/10/16.
//

import UIKit
import SnapKit

class Login2Controller: UIViewController {
    
    let login2View = Login2View()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(login2View)
        
        // layout
        login2View.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }

}
