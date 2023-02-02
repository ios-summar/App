//
//  SearchTableViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {

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
//        view.image = UIImage(named: "NonProfile")
        view.tintColor = UIColor.grayColor205
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    let nickName : UILabel = {
        let label = UILabel()
        label.font = FontManager.getFont(Font.Bold.rawValue).medium15Font
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    let major : UILabel = {
        let label = UILabel()
        label.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        label.textColor = UIColor.textColor115
        label.sizeToFit()
        label.numberOfLines = 2
        return label
    }()
    let introduceLabel : UILabel = {
        let label = UILabel()
        label.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        label.textColor = UIColor.fontGrayColor
        label.sizeToFit()
        label.numberOfLines = 2
        return label
    }()
    let followLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = FontManager.getFont(Font.Regular.rawValue).small11Font
        UILabel.textAlignment = .center
        UILabel.textColor = UIColor.fontGrayColor
        UILabel.sizeToFit()
        return UILabel
    }()
    
    func setUpCell(_ searchUserInfo: SearchUserInfo){
//        print("setUpCell \(searchUserInfo)")
        
        setProfileImage(profileImg, searchUserInfo.profileImageUrl)
        nickName.text = searchUserInfo.userNickname
        major.text = searchUserInfo.major2
        followLabel.text = "팔로워 \(searchUserInfo.follower!.commaRepresentation) · 팔로잉 \(searchUserInfo.following!.commaRepresentation)"
        
        print("searchUserInfo.introduce \(searchUserInfo.introduce)")
        
        guard let introduce = searchUserInfo.introduce else {
            remakeConstraints(true)
            return
        }
        remakeConstraints(false)
        self.introduceLabel.text = introduce
                
    }
    
    func setProfileImage(_ imageView: UIImageView,_ urlString: String?) {
        guard let urlString = urlString else {
            imageView.image = UIImage(named: "NonProfile")
            return
        }
        let url = URL(string: urlString)
        //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
        //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(
                  with: url,
                  placeholder: nil,
                  options: [.transition(.fade(1.2))],
                  completionHandler: nil
                )
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //기본 설정
        backgroundColor = UIColor.searchGray
        selectionStyle = .none
        
//        view.layer.borderWidth = 1
        contentView.addSubview(view)
        contentView.addSubview(profileImg)
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
            make.height.equalTo(120)
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
    
    func remakeConstraints(_ handler: Bool) {
        if handler {
            introduceLabel.snp.remakeConstraints{(make) in
                make.top.equalTo(major.snp.bottom).offset(6)
                make.height.equalTo(0)
                make.right.equalToSuperview()
                make.left.equalToSuperview()
            }
            view.snp.remakeConstraints{(make) in
                make.top.equalTo(15)
                make.left.equalTo(profileImg.snp.right).offset(10)
                make.right.equalTo(-20)
                make.height.equalTo(80)
                make.bottom.equalTo(-15)
            }
        }else {
            introduceLabel.snp.remakeConstraints{(make) in
                make.top.equalTo(major.snp.bottom).offset(6)
                make.height.equalTo(40)
                make.right.equalToSuperview()
                make.left.equalToSuperview()
            }
            view.snp.remakeConstraints{(make) in
                make.top.equalTo(15)
                make.left.equalTo(profileImg.snp.right).offset(10)
                make.right.equalTo(-20)
                make.height.equalTo(120)
                make.bottom.equalTo(-15)
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
        contentView.backgroundColor = .white
    }

}
