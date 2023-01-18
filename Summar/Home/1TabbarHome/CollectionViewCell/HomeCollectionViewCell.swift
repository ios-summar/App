//
//  HomeCollectionViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/15.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    let imgProudctPhoto = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor.BackgroundColor
        addSubview(imgProudctPhoto)
        
        imgProudctPhoto.snp.makeConstraints{(make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
