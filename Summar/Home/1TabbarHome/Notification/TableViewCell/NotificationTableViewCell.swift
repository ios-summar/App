//
//  NotificationTableViewCell.swift
//  Summar
//
//  Created by plsystems on 2023/02/21.
//

import Foundation
import UIKit
import SnapKit

protocol NotificationButtonDelegate: AnyObject {
    func btnAction(_ param: Dictionary<String, Int>, _ handler: String, completion: @escaping ()->())
}

final class NotificationTableViewCell: UITableViewCell, ViewAttributes {
    weak var delegate: NotificationButtonDelegate?
    let fontManager = FontManager.shared
    
    var model: NotificationList?
    
    lazy var profileImg : UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        view.layer.cornerRadius = 20
        view.tintColor = UIColor.grayColor205
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.tag = 1
        return view
    }()
    
    lazy var contentsLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = self.fontManager.getFont(Font.Regular.rawValue).mediumFont
        UILabel.textColor = UIColor.homeContentsColor
        UILabel.textAlignment = .left
        UILabel.numberOfLines = 3
        UILabel.lineBreakMode = .byCharWrapping
        UILabel.sizeToFit()
        return UILabel
    }()
    
    lazy var dateLabel : UILabel = {
        let label = UILabel()
        label.font = self.fontManager.getFont(Font.Regular.rawValue).smallFont
        label.textColor = UIColor.init(r: 115, g: 120, b: 127)
        label.sizeToFit()
        label.tag = 1
        return label
    }()
    lazy var btn : UIButton = {
        let button = UIButton()
        button.alpha = 0.0
        button.addTarget(self, action: #selector(followBtnAction(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.Gray02
        button.layer.cornerRadius = 4
        button.titleLabel?.font = self.fontManager.getFont(Font.SemiBold.rawValue).smallFont
        button.setTitleColor(UIColor.init(r: 70, g: 76, b: 83), for: .normal)
        button.setTitle("팔로우", for: .normal)
        button.tag = 2
        return button
    }()
    lazy var feedImg: UIImageView = {
        let view = UIImageView()
        view.alpha = 0.0
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.Gray02.cgColor
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()

        profileImg.image = nil
        contentsLabel.text = ""
        dateLabel.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell(_ model: NotificationList) {
        self.model = model
        guard let content = model.content, let createdDate = model.createdDate, let notificationType = model.notificationType else {return}
        
        setProfileImage(profileImg, model.imageUrl)
        setFeedImage(feedImg, model.feedImageUrl)
        
        contentsLabel.text = content
        dateLabel.text = compareDate(createdDate)
        
        
        switch notificationType {
        case "좋아요", "댓글":
            btn.alpha = 0.0
            feedImg.alpha = 1.0
            
            break
        case "팔로우":
            guard let followCheck = model.followCheck else {return}
            
            btn.alpha = 1.0
            feedImg.alpha = 0.0
            
            if followCheck {
                
                btn.setTitle("팔로우 취소", for: .normal)
                btn.backgroundColor = UIColor.Gray02
                btn.setTitleColor(UIColor.init(r: 70, g: 76, b: 83), for: .normal)
            }else {
                
                btn.setTitle("팔로우", for: .normal)
                btn.backgroundColor = UIColor.magnifyingGlassColor
                btn.setTitleColor(UIColor.white, for: .normal)
            }
            
            break
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
                      let resized = resize(image: imageResult.image, newWidth: 40)
                      imageView.image = resized
                      imageView.isHidden = false
                      case .failure(let error):
                          imageView.isHidden = true
                      }
                  })
            }
        }
    }
    
    func setFeedImage(_ imageView: UIImageView,_ urlString: String?) {
        guard let urlString = urlString else {
            imageView.image = UIImage(named: "NoExsitTemporarySaveImage")
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
                      let resized = resize(image: imageResult.image, newWidth: 60)
                      imageView.image = resized
                      imageView.isHidden = false
                      case .failure(let error):
                          imageView.isHidden = true
                      }
                  })
            }
        }
    }
    
    func setUI() {
        
        contentView.addSubview(profileImg)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(btn)
        contentView.addSubview(feedImg)
    }
    
    func setAttributes(){
        
        feedImg.snp.makeConstraints {
            
            $0.width.height.equalTo(60)
            $0.right.equalTo(-20)
            $0.centerY.equalToSuperview()
        }
        btn.snp.makeConstraints {
            
            $0.width.equalTo(70)
            $0.height.equalTo(31)
            $0.right.equalTo(-20)
            $0.centerY.equalToSuperview()
        }
        contentsLabel.snp.makeConstraints {
            
            $0.top.equalTo(profileImg.snp.top)
            $0.left.equalTo(profileImg.snp.right).offset(12)
            $0.right.equalTo(feedImg.snp.left).offset(-12)
        }
        dateLabel.snp.makeConstraints {

            $0.bottom.equalTo(-16)
            $0.left.equalTo(contentsLabel.snp.left)
        }
        profileImg.snp.makeConstraints {
            
            $0.width.height.equalTo(40)
            $0.top.equalTo(feedImg.snp.top)
            $0.left.equalTo(20)
        }
    }
    
    @objc func followBtnAction(_ sender: Any) {
        guard let opponentUserSeq = self.model?.otherUserSeq else {return}
        
        let text = btn.titleLabel?.text
        
        if text == "팔로우 취소" {
            
            smLog("언팔, 삭제(내 userSeq \(getMyUserSeq()) -> 상대 userSeq\(opponentUserSeq)")

            let param : Dictionary<String, Int> = [
                "followedUserSeq": opponentUserSeq,
                "followingUserSeq": getMyUserSeq()
            ]
            self.delegate?.btnAction(param, "DELETE", completion: {
                UIDevice.vibrate()
                
                self.btn.setTitle("팔로우", for: .normal)
                self.btn.backgroundColor = UIColor.magnifyingGlassColor
                self.btn.setTitleColor(UIColor.white, for: .normal)

                toast("팔로우 취소")
            })
            
        }else if text == "팔로우" {
            
            smLog("팔로우, 추가(내 userSeq\(getMyUserSeq()) -> 상대 userSeq\(opponentUserSeq)")

            let param : Dictionary<String, Int> = [
                "followedUserSeq": opponentUserSeq,
                "followingUserSeq": getMyUserSeq()
            ]
            self.delegate?.btnAction(param, "POST", completion: {
                UIDevice.vibrate()
                
                self.btn.setTitle("팔로우 취소", for: .normal)
                self.btn.backgroundColor = UIColor.Gray02
                self.btn.setTitleColor(UIColor.init(r: 70, g: 76, b: 83), for: .normal)

                toast("팔로우")
            })
        }
    }
}
