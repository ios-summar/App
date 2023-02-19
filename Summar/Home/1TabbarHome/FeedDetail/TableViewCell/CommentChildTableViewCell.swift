//
//  CommentChildTableViewCell.swift
//  Summar
//
//  Created by plsystems on 2023/02/02.
//

import Foundation
import UIKit

final class CommentChildTableViewCell: UITableViewCell, ViewAttributes{
    weak var delegate: PushDelegate?
    weak var reloadDelegate: TableViewReload?
    let helper = Helper.shared
    let fontManager = FontManager.shared
    let viewModel = FeedDetailViewModel()
    var comment: Comment?
    
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
        label.font = self.fontManager.getFont(Font.Bold.rawValue).mediumFont
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
        label.font = self.fontManager.getFont(Font.Regular.rawValue).smallFont
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
        UIButton.tag = 1
        UIButton.setImage(UIImage(named: "meetballMenu"), for: .normal)
        UIButton.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        UIButton.sizeToFit()
        return UIButton
    }()
    lazy var contentsLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = self.fontManager.getFont(Font.SemiBold.rawValue).smallFont
        UILabel.textColor = UIColor.homeContentsColor
        UILabel.textAlignment = .left
        UILabel.numberOfLines = 0
        UILabel.lineBreakMode = .byTruncatingTail
        UILabel.sizeToFit()
        return UILabel
    }()
    
    func setUpCell(_ comment: Comment){
        guard let user = comment.user, let major2 = user.major2, let activated = comment.activated else {return}
        
        self.comment = comment
        
        switch activated {
        case true:
            setProfileImage(profileImg, user.profileImageUrl)
            nickName.text = user.userNickname
            major.text = "\(major2) / \(compareDate(comment.createdDate))"
            contentsLabel.text = comment.comment
            contentsLabel.textColor = .black
            helper.lineSpacing(contentsLabel, 5)
            
        case false:
            profileImg.image = UIImage(named: "NonProfile")
            nickName.text = "(알 수 없음)"
            major.text = ""
            contentsLabel.text = "(삭제된 댓글입니다.)"
            contentsLabel.textColor = .lightGray
            helper.lineSpacing(contentsLabel, 5)
            
        default:
            break
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
                    completionHandler: { result in
                    switch(result) {
                        case .success(let imageResult):
                        let resized = resizeImage(image: imageResult.image, newWidth: 32)
                        imageView.image = resized
                        imageView.isHidden = false
                        case .failure(let error):
                            imageView.isHidden = true
                        }
                    })
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
        contentView.addSubview(profileImg)
        contentView.addSubview(nickName)
        contentView.addSubview(major)
        contentView.addSubview(meetballMenu)
        contentView.addSubview(contentsLabel)
    }
    
    func setAttributes(){
        profileImg.snp.makeConstraints { (make) in
            
            make.top.equalTo(12)
            make.left.equalTo(64)
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
            make.bottom.equalTo(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didSelect(_ sender: UITapGestureRecognizer) {
        guard let userSeq = comment?.user?.userSeq, let activated = comment?.activated else {return}
        
        if activated {
            self.delegate?.pushScreen(ProfileViewController(), userSeq)
        }else {
            print("삭제된 댓글")
        }
    }
    
    @objc func btnAction(_ sender: Any){
        guard let userSeq = comment?.user?.userSeq, let feedCommentSeq = comment?.feedCommentSeq, let feedSeq = comment?.feedSeq else {return}
        let tag = (sender as AnyObject).tag as! Int
        
        switch tag {
        case 1: // 신고하기, 삭제하기
            smLog("1")
            var message = ""
            if userSeq == getMyUserSeq() { // 내 댓글
                message = "삭제하기"
            }else { // 내 댓글 아님
                message = "신고하기"
            }
            
            helper.showAlertAction(vc: self, message: message) { handler in
                
                switch handler {
                case "삭제하기":
                    self.viewModel.commentRemove(feedCommentSeq)
                    self.viewModel.didFinishCommentRemoveFetch = {
                        toast("댓글 삭제완료")
                        
                        self.reloadDelegate?.tableViewReload()
                    }
                    break
                case "신고하기":
                    let param: Dictionary<String, Any> = [
                        "mySeq": getMyUserSeq(),
                        "userSeq": userSeq,
                        "feedSeq": feedSeq,
                        "feedCommentSeq": feedCommentSeq
                    ]
                    
                    self.delegate?.pushScreen(ReportViewController(), param)
                default:
                    break
                }
            }
        case 2:
            smLog("2")
        default:
            break
        }
    }
}
