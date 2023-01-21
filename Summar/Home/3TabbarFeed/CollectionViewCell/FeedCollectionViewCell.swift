//
//  FeedCollectionViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/28.
//

import UIKit
import SnapKit
import QuartzCore

class FeedCollectionViewCell: UICollectionViewCell {
    lazy var view : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1).cgColor
        return view
    }()
    
    let btn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        return btn
    }()
    
    let label1 : UILabel = {
        let UILabel = UILabel()
        UILabel.text = "이미지\n추가하기"
        UILabel.textColor = UIColor.fontColor
        UILabel.numberOfLines = 0
        UILabel.font = FontManager.getFont(Font.Bold.rawValue).mediumFont
        UILabel.sizeToFit()
        UILabel.textAlignment = .center
        return UILabel
    }()
    
    let label2 : UILabel = {
        let UILabel = UILabel()
        UILabel.text = "(10건 이하)"
        UILabel.textColor = UIColor.fontColor
        UILabel.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        UILabel.sizeToFit()
        return UILabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        _ = [view].map {
            addSubview($0)
        }
        
        _ = [btn, label1, label2].map {
            view.addSubview($0)
        }
        
        view.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(25)
//            make.right.equalTo(-25)
            make.width.height.equalTo(100)
        }
        
        btn.snp.makeConstraints{(make) in
            make.edges.equalToSuperview()
        }
        
        label1.snp.makeConstraints{(make) in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
        }
        
        label2.snp.makeConstraints{(make) in
            make.top.equalTo(label1.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
