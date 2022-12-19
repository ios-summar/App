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
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(#file , #function)
    }
}
