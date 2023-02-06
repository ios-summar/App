//
//  FollowListTableViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import UIKit

final class FollowListTableViewCell: UITableViewCell, ViewAttributes {
    weak var delegate: PushDelegate?
    var userSeq: Int?
    
    let profileImg : UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        view.layer.cornerRadius = 24
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
    let btn : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(followBtnAction(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.Gray02
        button.layer.cornerRadius = 4
        button.titleLabel?.font = FontManager.getFont(Font.SemiBold.rawValue).smallFont
        button.setTitleColor(UIColor.init(r: 70, g: 76, b: 83), for: .normal)
        return button
    }()
    
    func setUpCell(_ follow: SearchUserInfo, _ handler: String){
        self.userSeq = follow.userSeq
        
        setProfileImage(profileImg, follow.profileImageUrl)
        nickName.text = follow.userNickname
        major.text = follow.major2
        
        if handler == "follower" {
            btn.setTitle("삭제", for: .normal)
        }else if handler == "following" {
            btn.setTitle("팔로우 취소", for: .normal)
        }
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
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        setUI()
        setAttributes()
    }
    
    func setUI() {
        contentView.addSubview(profileImg)
        contentView.addSubview(nickName)
        contentView.addSubview(major)
        contentView.addSubview(btn)
    }
    
    func setAttributes() {
        profileImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.height.equalTo(48)
        }
        
        nickName.snp.makeConstraints { (make) in
            make.left.equalTo(profileImg.snp.right).offset(12)
            make.bottom.equalTo(profileImg.snp.centerY).offset(-5)
        }
        
        major.snp.makeConstraints { (make) in
            make.left.equalTo(nickName.snp.left)
            make.top.equalTo(profileImg.snp.centerY).offset(5)
        }
        
        btn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-20)
            $0.width.equalTo(70)
            $0.height.equalTo(31)
        }
    }
    
    @objc func followBtnAction(_ sender: Any) {
        smLog("")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
