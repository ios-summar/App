//
//  CommentTableViewCell.swift
//  Summar
//
//  Created by plsystems on 2023/02/02.
//

import Foundation
import UIKit

final class CommentTableViewCell: UITableViewCell, ViewAttributes{
    let helper = Helper()
    
    lazy var profileImg : UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        view.layer.cornerRadius = 16
        view.tintColor = UIColor.grayColor205
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true

        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelect(_:))
        )
        view.addGestureRecognizer(recognizer)
        
        return view
    }()
    lazy var nickName : UILabel = {
        let label = UILabel()
        label.font = FontManager.getFont(Font.Bold.rawValue).mediumFont
        label.textColor = .black
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelect(_:))
        )
        label.addGestureRecognizer(recognizer)
        return label
    }()
    lazy var major : UILabel = {
        let label = UILabel()
        label.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        label.textColor = UIColor.init(r: 115, g: 120, b: 127)
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelect(_:))
        )
        label.addGestureRecognizer(recognizer)
        return label
    }()
    lazy var meetballMenu: UIButton = {
        let UIButton = UIButton()
        UIButton.setImage(UIImage(named: "meetballMenu"), for: .normal)
        UIButton.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        UIButton.sizeToFit()
        return UIButton
    }()
    lazy var contentsLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = FontManager.getFont(Font.SemiBold.rawValue).smallFont
        UILabel.textColor = UIColor.homeContentsColor
        UILabel.textAlignment = .left
        UILabel.numberOfLines = 0
        UILabel.lineBreakMode = .byTruncatingTail
        UILabel.sizeToFit()
        return UILabel
    }()
    lazy var commentBtn : UIButton = {
        let UIButton = UIButton()
        UIButton.titleLabel?.font = FontManager.getFont(Font.SemiBold.rawValue).smallFont
        UIButton.setTitle("답글 쓰기", for: .normal)
        UIButton.setTitleColor(UIColor.init(r: 115, g: 120, b: 127), for: .normal)
        UIButton.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
//        UIButton.sizeToFit()
        return UIButton
    }()
    
    func setUpCell(_ Comment: Comment){
        guard let user = Comment.user, let major2 = user.major2 else {return}
        
        setProfileImage(profileImg, user.profileImageUrl)
        nickName.text = user.userNickname
        major.text = "\(major2) / \(compareDate(Comment.createdDate))"
        contentsLabel.text = Comment.comment
        helper.lineSpacing(contentsLabel, 5)
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
        selectionStyle = .none
        
        setUI()
        setAttributes()
    }
    
    
    func setUI(){
        contentView.layer.borderWidth = 1
        contentView.addSubview(profileImg)
        contentView.addSubview(nickName)
        contentView.addSubview(major)
        contentView.addSubview(meetballMenu)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(commentBtn)
    }
    
    func setAttributes(){
        profileImg.snp.makeConstraints { (make) in
            
            make.top.equalTo(24)
            make.left.equalTo(20)
            make.width.height.equalTo(32)
        }
        nickName.snp.makeConstraints { (make) in
            
            make.top.equalTo(profileImg.snp.top).offset(-4)
            make.left.equalTo(profileImg.snp.right).offset(12)
        }
        major.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(profileImg.snp.bottom)
            make.left.equalTo(profileImg.snp.right).offset(12)
        }
        meetballMenu.snp.makeConstraints { (make) in
            
            make.width.height.equalTo(16)
            make.top.equalTo(nickName.snp.top)
            make.right.equalTo(-20)
        }
        contentsLabel.snp.makeConstraints { (make) in
         
            make.left.equalTo(major.snp.left)
            make.top.equalTo(major.snp.bottom).offset(10)
            make.right.equalTo(-20)
        }
        commentBtn.snp.makeConstraints { (make) in
            
            make.left.equalTo(major.snp.left)
            make.top.equalTo(contentsLabel.snp.bottom).offset(10)
            make.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didSelect(_ sender: UITapGestureRecognizer) {
        smLog("")
//        guard let userSeq = userSeq else {return}
//        self.delegate?.pushScreen(ProfileViewController.shared, userSeq)
    }
    @objc func btnAction(_ sender: Any){
        smLog("")
    }
}
