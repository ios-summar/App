//
//  ReportTableViewCell.swift
//  Summar
//
//  Created by plsystems on 2023/02/09.
//

import UIKit

final class ReportTableViewCell: UITableViewCell, ViewAttributes {
    
    let label : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = FontManager.getFont(Font.SemiBold.rawValue).mediumFont
        return label
    }()
    
    let rectangleStroke : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "RectangleStroke")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white

        setUI()
        setAttributes()
    }
    
    func setUpCell(index: Int,_ content: String) {
        
        switch index {
        case 0:
            selectionStyle = .none
            label.textColor = .systemBlue
            rectangleStroke.alpha = 0.0
        default:
            break
        }
        
        label.text = content
    }
    
    func setUI() {
        contentView.addSubview(label)
        contentView.addSubview(rectangleStroke)
    }
    
    func setAttributes() {
        label.snp.makeConstraints{(make) in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        rectangleStroke.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
