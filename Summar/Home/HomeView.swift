//
//  HomeView.swift
//  Summar
//
//  Created by mac on 2022/11/02.
//

import Foundation
import UIKit


class HomeView: UIView{
    static let shared = HomeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let userEmail = UserDefaults.standard.string(forKey: "userEmail")
        let userNickName = UserDefaults.standard.string(forKey: "userNickName")
        let major1 = UserDefaults.standard.string(forKey: "major1")
        let major2 = UserDefaults.standard.string(forKey: "major2")
        let socialType = UserDefaults.standard.string(forKey: "socialType")
        
        if let value = userEmail{
            print("userEmail => ", value)
        }
        
        if let value = userNickName{
            print("userNickName => ", value)
        }
        
        if let value = major1{
            print("major1 => ", value)
        }
        
        if let value = major2{
            print("major2 => ", value)
        }
        
        if let value = socialType{
            print("socialType => ", value)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
