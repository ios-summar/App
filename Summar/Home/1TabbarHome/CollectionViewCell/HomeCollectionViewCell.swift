//
//  HomeCollectionViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/15.
//

import UIKit

final class HomeCollectionViewCell: UICollectionViewCell {
    let imgProudctPhoto : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor.BackgroundColor
        addSubview(imgProudctPhoto)
        
        imgProudctPhoto.snp.makeConstraints{(make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
