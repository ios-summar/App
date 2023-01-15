//
//  NoticeTableViewCell.swift
//  Summar
//
//  Created by ukBook on 2023/01/15.
//

import Foundation
import UIKit

class NoticeContentTableViewCell: UITableViewCell {
    
    let view = UIView()

    let tableLabel : UILabel = {
        let label = UILabel()
        label.text = "123"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
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
        
        view.addSubview(tableLabel)
        tableLabel.snp.makeConstraints {
            $0.top.equalTo(12)
            $0.bottom.equalTo(-12)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
