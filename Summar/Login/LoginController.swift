//
//  ViewController.swift
//  Summar
//
//  Created by ukBook on 2022/09/08.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(loginView)
        
        // layout
        loginView.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }

}

