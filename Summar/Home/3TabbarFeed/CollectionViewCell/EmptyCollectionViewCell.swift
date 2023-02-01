//
//  EmptyCollectionViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import Foundation
import SnapKit

final class EmptyCollectionViewCell: UICollectionViewCell {
    var view : UIView = {
        let view = UIButton()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        _ = [view].map {
            addSubview($0)
        }
        
        view.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(25)
            make.width.equalTo(25)
            make.height.equalTo(100)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
