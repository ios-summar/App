//
//  NoticeTableViewCell.swift
//  Summar
//
//  Created by ukBook on 2023/01/15.
//

import Foundation
import UIKit

final class NoticeContentTableViewCell: UITableViewCell {
    let fontManager = FontManager.shared
    let view = UIView()

    lazy var tableLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor115
        label.font = self.fontManager.getFont(Font.Regular.rawValue).medium15Font
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white

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
