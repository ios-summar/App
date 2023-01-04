//
//  PreferencesTableViewCell.swift
//  Summar
//
//  Created by mac on 2023/01/04.
//

import UIKit

class PreferencesTableViewCell: UITableViewCell {
    
    let label : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        
        label.snp.makeConstraints{(make) in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
