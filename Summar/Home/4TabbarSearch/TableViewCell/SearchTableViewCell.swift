//
//  SearchTableViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    // imageView, label 3

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
