//
//  FollowListTableViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import UIKit

final class FollowListTableViewCell: UITableViewCell, ViewAttributes {
    weak var delegate: PushDelegate?
    weak var refreshDelegate: RefreshFollowList?
    let viewModel = MyInfoViewModel(nil, nil)
    var userSeq: Int?
    var setUpTuple: (String, Bool) = ("", true)
    
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
    lazy var followBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(followBtnAction(_:)), for: .touchUpInside)
        button.titleLabel?.font = FontManager.getFont(Font.Bold.rawValue).smallFont
        button.setTitleColor(UIColor.magnifyingGlassColor, for: .normal)
        button.tag = 1
        button.setTitle("팔로우", for: .normal)
        return button
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
        button.tag = 2
        return button
    }()
    
    func setUpCell(_ follow: SearchUserInfo, _ handler: String, _ myFollowList: Bool){
        smLog("\(myFollowList)")
        setUpTuple = (handler, myFollowList)
        
        self.userSeq = follow.userSeq
        
        setProfileImage(profileImg, follow.profileImageUrl)
        nickName.text = follow.userNickname
        major.text = follow.major2
        
        switch setUpTuple {
        case ("follower", true): // 팔로워, 내 팔로우 리스트
            guard let followUp = follow.followUp else {return}
            
            print("#팔로워, 내피드 (follower, true)")
            btn.setTitle("삭제", for: .normal)
            
            if !followUp {
                contentView.addSubview(followBtn)
                followBtn.snp.makeConstraints {
                    $0.centerY.equalTo(nickName.snp.centerY)
                    $0.left.equalTo(nickName.snp.right).offset(6)
                    $0.height.equalTo(31)
                    $0.width.equalTo(40)
                }
            }
        case ("following", true): // 팔로잉, 내 팔로우 리스트
            print("#팔로잉, 내피드 (following, true)")
            btn.setTitle("팔로우 취소", for: .normal)
            btn.backgroundColor = UIColor.Gray02
            btn.setTitleColor(UIColor.init(r: 70, g: 76, b: 83), for: .normal)
            
        case ("follower", false), ("following", false): // 팔로워, 내 팔로우 리스트 아님
            guard let followStatus = follow.followStatus, let followSeq = follow.userSeq else {return}
            print("#팔로워, 내피드 아님 (follower, false), #팔로잉, 내피드 아님 (following, false) \(followStatus)")
            
            switch followStatus {
            case "나자신":
                btn.removeFromSuperview()
                
            case "한쪽팔로우", "맞팔":
                self.btn.setTitle("팔로우 취소", for: .normal)
                self.btn.backgroundColor = UIColor.Gray02
                self.btn.setTitleColor(UIColor.init(r: 70, g: 76, b: 83), for: .normal)
                
            case "암것도아님":
                self.btn.setTitle("팔로우", for: .normal)
                self.btn.backgroundColor = UIColor.magnifyingGlassColor
                self.btn.setTitleColor(UIColor.white, for: .normal)
                
            default:
                print("default")
            }

        default:
            print("default")
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
        guard let tag = (sender as AnyObject).tag as? Int else {return}
        guard let opponentUserSeq = self.userSeq else {return}
        UIDevice.vibrate()
        
        switch tag {
        case 1:
            smLog("팔로우, 추가(내 userSeq\(getMyUserSeq()) -> 상대 userSeq\(opponentUserSeq)")
            
            let param : Dictionary<String, Int> = ["followedUserSeq": opponentUserSeq, "followingUserSeq": getMyUserSeq()]
            viewModel.followAction(param, "POST")
            viewModel.didFinishFollowFetch = {
                self.followBtn.removeFromSuperview()
                
                toast("팔로우")
            }
        case 2:
            print("삭제, 팔로우 취소, 팔로우")
            let text = btn.titleLabel?.text
            
            switch setUpTuple {
            case ("follower", true): // 팔로워, 내피드
                smLog("팔로워, 내피드")
                if text == "삭제" {
                    smLog("삭제(상대 userSeq -> 내 userSeq)")
                    
                    let param : Dictionary<String, Int> = [
                        "followedUserSeq": getMyUserSeq(),
                        "followingUserSeq": opponentUserSeq
                    ]
                    
                    viewModel.followAction(param, "DELETE")
                    viewModel.didFinishFollowFetch = {
                        self.refreshDelegate?.refreshTabManTitle()
                        toast("삭제됨")
                    }
                }
            case ("following", true),("follower", false), ("following", false): // (팔로잉, 내피드), (팔로워, 내피드 아님), (팔로잉, 내피드 아님)
                if text == "팔로우 취소" {
                    smLog("언팔, 삭제(내 userSeq \(getMyUserSeq()) -> 상대 userSeq\(opponentUserSeq)")
                    
                    let param : Dictionary<String, Int> = [
                        "followedUserSeq": opponentUserSeq,
                        "followingUserSeq": getMyUserSeq()
                    ]
                    
                    viewModel.followAction(param, "DELETE")
                    viewModel.didFinishFollowFetch = {
                        self.btn.setTitle("팔로우", for: .normal)
                        self.btn.backgroundColor = UIColor.magnifyingGlassColor
                        self.btn.setTitleColor(UIColor.white, for: .normal)
                        
                        toast("팔로우 취소")
                    }
                }else if text == "팔로우" {
                    smLog("다시 팔로우, 추가(내 userSeq\(getMyUserSeq()) -> 상대 userSeq\(opponentUserSeq)")
                    
                    let param : Dictionary<String, Int> = [
                        "followedUserSeq": opponentUserSeq,
                        "followingUserSeq": getMyUserSeq()
                    ]
                    
                    viewModel.followAction(param, "POST")
                    viewModel.didFinishFollowFetch = {
                        self.btn.setTitle("팔로우 취소", for: .normal)
                        self.btn.backgroundColor = UIColor.Gray02
                        self.btn.setTitleColor(UIColor.init(r: 70, g: 76, b: 83), for: .normal)
                        
                        toast("팔로우")
                    }
                }
            default:
                print("default1")
            }
        default:
            print("default2")
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
