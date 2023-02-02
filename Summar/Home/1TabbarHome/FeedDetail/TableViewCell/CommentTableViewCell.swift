//
//  CommentTableViewCell.swift
//  Summar
//
//  Created by plsystems on 2023/02/02.
//

import Foundation
import UIKit

class CommentTableViewCell: UITableViewCell, ViewAttributes{
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
        UIButton.sizeToFit()
        return UIButton
    }()
    
    func TEST(){
        profileImg.layer.borderWidth = 1
        nickName.text = "임세모"
        major.text = "컴퓨터 / 통신 5시간전"
        contentsLabel.text = "베니테이블 온보딩 웰컴키트를 제작하면서 실용성과 베니테이블 온보딩 웰컴키트를 제작하면서 실용성과 베니테이블 온보딩 웰컴키트를 제작하면서 실용성과 베니테이블 온보딩 웰컴키트를 제작하면서 실용성과"
        
        helper.lineSpacing(contentsLabel, 5)
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
            
            make.top.equalTo(12)
            make.left.equalTo(20)
            make.width.height.equalTo(32)
        }
        nickName.snp.makeConstraints { (make) in
            
            make.top.equalTo(profileImg.snp.top)
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
        commentBtn.layer.borderWidth = 1
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
