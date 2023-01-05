//
//  HomeTableViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    let helper = Helper()
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
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    let introductLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .systemFont(ofSize: 16)
        UILabel.textColor = .systemGray
        UILabel.textAlignment = .left
        UILabel.numberOfLines = 3
        return UILabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImg)
        contentView.addSubview(nickName)
        contentView.addSubview(major)
        contentView.addSubview(introductLabel)
        
        profileImg.snp.makeConstraints { (make) in
            
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.width.height.equalTo(55)
        }
        nickName.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(profileImg.snp.centerY).offset(-1)
            make.left.equalTo(profileImg.snp.right).offset(10)
        }
        major.snp.makeConstraints { (make) in
            
            make.top.equalTo(profileImg.snp.centerY).offset(2)
            make.left.equalTo(profileImg.snp.right).offset(10)
        }
        introductLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(profileImg.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(100)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(#file , #function)
        
        print("!contentView.frame \(contentView.frame)")
        print("!contentView \(contentView)")
        
        contentView.backgroundColor = .white
        
        
        // table view margin
          contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        print("!contentView.frame \(contentView.frame)")
    }

}
