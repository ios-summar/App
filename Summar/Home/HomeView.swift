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
    
    let title : UIImageView = {
        let title = UIImageView()
        title.image = UIImage(named: "Title")
        return title
    }()
    
    let directBtn : UIButton = {
        let directBtn = UIButton()
        directBtn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        directBtn.tintColor = .black
        directBtn.imageView?.contentMode = .scaleToFill
        directBtn.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 33, right: 35)
        directBtn.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        directBtn.tag = 2
        return directBtn
    }()
    
    let heartBtn : UIButton = {
        let heartBtn = UIButton()
        heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        heartBtn.tintColor = .black
        heartBtn.imageView?.contentMode = .scaleToFill
        heartBtn.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 33, right: 35)
        heartBtn.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        heartBtn.tag = 1
        return heartBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        addSubview(directBtn)
        addSubview(heartBtn)
        
        title.snp.makeConstraints{(make) in
            make.topMargin.equalTo(10)
            make.leftMargin.equalTo(30)
            make.width.equalTo(72)
            make.height.equalTo(18)
        }
        
        directBtn.snp.makeConstraints{(make) in
            make.centerY.equalTo(title.snp.centerY)
            make.rightMargin.equalTo(-20)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        heartBtn.snp.makeConstraints{(make) in
            make.centerY.equalTo(title.snp.centerY)
            make.rightMargin.equalTo(directBtn.snp.left).offset(-20)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
//        let userEmail = UserDefaults.standard.string(forKey: "userEmail")
//        let userNickName = UserDefaults.standard.string(forKey: "userNickName")
//        let major1 = UserDefaults.standard.string(forKey: "major1")
//        let major2 = UserDefaults.standard.string(forKey: "major2")
//        let socialType = UserDefaults.standard.string(forKey: "socialType")
//
//        if let value = userEmail{
//            print("userEmail => ", value)
//        }
//
//        if let value = userNickName{
//            print("userNickName => ", value)
//        }
//
//        if let value = major1{
//            print("major1 => ", value)
//        }
//
//        if let value = major2{
//            print("major2 => ", value)
//        }
//
//        if let value = socialType{
//            print("socialType => ", value)
//        }
        
    }
    
    @objc func topBtnAction(_ sender: Any) {
        let tagValue = (sender as? UIButton)?.tag
        
        switch tagValue {
        case 1: // Heart Event
            print("heart")
        case 2: // DirectMessage Event
            print("DirectMessage")
        default:
            print("default")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
