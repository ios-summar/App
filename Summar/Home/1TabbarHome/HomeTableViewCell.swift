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
        addSubview(profileImg)
        addSubview(nickName)
        addSubview(major)
        addSubview(introductLabel)
        
//        backgroundColor = .systemPink
        profileImg.snp.makeConstraints { (make) in
            
            make.top.equalTo(40)
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
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }

}
