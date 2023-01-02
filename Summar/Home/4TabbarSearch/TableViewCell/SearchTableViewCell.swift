//
//  SearchTableViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    // imageView, label 3
    
    let profileImg : UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        view.layer.cornerRadius = 27.5
        view.image = UIImage(systemName: "person.fill")
        view.tintColor = UIColor.grayColor205
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    let nickName : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    let major : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        label.sizeToFit()
        label.numberOfLines = 2
        return label
    }()
    let followLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .boldSystemFont(ofSize: 16)
        UILabel.textAlignment = .center
        UILabel.textColor = .black
        UILabel.text = "팔로워 200"
        UILabel.sizeToFit()
        return UILabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _ = [profileImg, nickName, major, followLabel].map {
            addSubview($0)
        }
        
        profileImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.height.equalTo(55)
        }
        
        nickName.snp.makeConstraints { (make) in
//            make.bottom.equalTo(profileImg.snp.centerY).offset(-1)
            make.top.equalTo(9)
            make.left.equalTo(profileImg.snp.right).offset(10)
            make.height.equalTo(20)
        }
        
        followLabel.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        major.snp.makeConstraints { (make) in
            make.top.equalTo(nickName.snp.bottom).offset(2)
            make.left.equalTo(profileImg.snp.right).offset(10)
            make.right.equalTo(followLabel.snp.left).offset(-10)
            make.bottom.equalTo(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
