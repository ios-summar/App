//
//  PreferencesTableViewCell.swift
//  Summar
//
//  Created by mac on 2023/01/04.
//

import UIKit

class PreferencesTableViewCell: UITableViewCell {

    let preferencesImg : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.fill")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    let label : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var versionLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 115, g: 120, b: 127)
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    
    lazy var updateLabel : UILabel = {
        let label = UILabel()
        label.text = "업데이트를 진행해 주세요"
        label.textColor = UIColor.updateColor
        label.font = .systemFont(ofSize: 11)
        label.alpha = 0.0
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
        selectionStyle = .none

        _ = [preferencesImg, label, versionLabel, updateLabel, rectangleStroke].map {
            addSubview($0)
        }
        preferencesImg.snp.makeConstraints{(make) in
            make.width.height.equalTo(24)
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints{(make) in
            make.left.equalTo(preferencesImg.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        
        versionLabel.snp.makeConstraints{(make) in
            make.left.equalTo(label.snp.right).offset(7)
            make.centerY.equalToSuperview()
        }
        
        updateLabel.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(rectangleStroke.snp.left).offset(-8)
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
