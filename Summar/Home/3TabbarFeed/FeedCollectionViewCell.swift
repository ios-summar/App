//
//  FeedCollectionViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/28.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    let btn : UIButton = {
        let btn = UIButton()
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemRed.cgColor
        return btn
    }()
    
    let btn1 : UIButton = {
        let btn = UIButton()
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.summarColor1.cgColor
        return btn
    }()
    
    let btn2 : UIButton = {
        let btn = UIButton()
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.summarColor1.cgColor
        return btn
    }()
    
    let btn3 : UIButton = {
        let btn = UIButton()
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.summarColor1.cgColor
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor.BackgroundColor
        addSubview(btn)
        addSubview(btn1)
        
        _ = [btn, btn1, btn2, btn3].map {
            addSubview($0)
            $0.layer.borderWidth = 1
        }
        
        btn.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(25)
            make.width.height.equalTo(100)
        }
        
        btn1.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(btn.snp.right).offset(20)
            make.width.height.equalTo(100)
        }
        
        btn2.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(btn1.snp.right).offset(20)
            make.width.height.equalTo(100)
        }
        
        btn3.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(btn2.snp.right).offset(20)
            make.width.height.equalTo(100)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
