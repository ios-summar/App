//
//  SignUp3Controller.swift
//  Summar
//
//  Created by ukBook on 2022/10/23.
//

import Foundation
import UIKit
import SnapKit

class SignUp3Controller : UIViewController{
    static let shared = SignUp3Controller()
    
    let helper : Helper = Helper()
    
    var requestDic: Dictionary<String, String> = Dictionary<String, String>()
    
    let signUp3View = SignUp3View.shared
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.addSubview(signUp3View)
        
        signUp3View.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
 }
