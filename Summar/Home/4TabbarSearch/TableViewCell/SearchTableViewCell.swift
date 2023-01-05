//
//  SearchTableViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    // imageView, label 3
    
    let view : UIView = {
        let view = UIView()
        return view
    }()
    
    let profileImg : UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        view.layer.cornerRadius = 20
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
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = UIColor.init(red: 115/255, green: 120/255, blue: 127/255, alpha: 1)
        label.sizeToFit()
        label.numberOfLines = 2
        return label
    }()
    let introduceLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor.init(red: 115/255, green: 120/255, blue: 127/255, alpha: 1)
        label.sizeToFit()
        label.numberOfLines = 2
        return label
    }()
    let followLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .systemFont(ofSize: 13)
        UILabel.textAlignment = .center
        UILabel.textColor = UIColor.fontGrayColor
//        UILabel.text = "팔로워 200"
        UILabel.sizeToFit()
        return UILabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(view)
        addSubview(profileImg)
        _ = [nickName, major, followLabel, introduceLabel].map {
            view.addSubview($0)
//            $0.layer.borderWidth = 1
        }
        
        profileImg.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(20)
            make.width.height.equalTo(40)
        }
        
        view.snp.makeConstraints{(make) in
            make.top.equalTo(15)
            make.left.equalTo(profileImg.snp.right).offset(10)
            make.right.equalTo(-20)
            make.bottom.equalTo(-15)
        }
        
        nickName.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        major.snp.makeConstraints { (make) in
            make.top.equalTo(nickName.snp.bottom).offset(6)
            make.left.equalToSuperview()
        }
        
        followLabel.snp.makeConstraints{(make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        introduceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(major.snp.bottom).offset(6)
            make.height.equalTo(40)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
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
