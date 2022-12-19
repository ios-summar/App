//
//  TitleViewMyInfo.swift
//  Summar
//
//  Created by mac on 2022/11/02.
//

import Foundation
import UIKit


class TitleViewMyInfo: UIView{
    static let shared = TitleViewMyInfo()
    
    let title : UILabel = {
        let title = UILabel()
        title.text = "마이 써머리"
        title.font = .boldSystemFont(ofSize: 20)
        title.textColor = UIColor.summarColor1
        title.sizeToFit()
        return title
    }()
    
    let gear : UIButton = {
        let gear = UIButton()
        gear.setImage(UIImage(systemName: "gearshape"), for: .normal) // ios 14.0
        gear.tintColor = .black
        gear.imageView?.contentMode = .scaleToFill
        gear.imageEdgeInsets = UIEdgeInsets(top: 32, left: 33, bottom: 33, right: 33)
        gear.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        gear.tag = 1
//        gear.layer.borderWidth = 1
        return gear
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        addSubview(gear)
        
        backgroundColor = UIColor.BackgroundColor
        
        title.snp.makeConstraints{(make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        gear.snp.makeConstraints{(make) in
            make.centerY.equalTo(title.snp.centerY)
            make.rightMargin.equalTo(-20)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    @objc func topBtnAction(_ sender: Any) {
        let tagValue = (sender as? UIButton)?.tag
        
        switch tagValue {
        case 1: // Heart Event
            print("gear")
        default:
            print("default")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
