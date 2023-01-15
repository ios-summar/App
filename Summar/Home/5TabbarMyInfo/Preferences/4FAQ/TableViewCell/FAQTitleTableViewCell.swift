//
//  FAQTitleTableViewCell.swift
//  Summar
//
//  Created by ukBook on 2023/01/15.
//

import Foundation
import UIKit

class FAQTitleTableViewCell: UITableViewCell {
    
    let view = UIView()
    var selectBool = false

    let tableLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byClipping
        label.sizeToFit()
        return label
    }()
    
    let upDownImageView : UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "Down")
        label.tintColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.searchGray.cgColor
        
        addSubview(view)
        view.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(upDownImageView)
        upDownImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-20)
            $0.width.height.equalTo(24)
        }
        
        view.addSubview(tableLabel)
        tableLabel.snp.makeConstraints {
            $0.top.left.equalTo(20)
            $0.bottom.equalTo(-20)
            $0.right.equalTo(upDownImageView.snp.left).offset(-5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
