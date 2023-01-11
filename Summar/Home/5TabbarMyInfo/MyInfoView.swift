//
//  MyInfoView.swift
//  Summar
//
//  Created by mac on 2022/12/14.
// https://hryang.tistory.com/7 => scrollview programmatically

import Foundation
import UIKit

// MARK: - MyInfoView -> MyInfoViewController userInfo 인자전달
protocol MyInfoViewDelegate : AnyObject {
    func parameter(_ userInfo: UserInfo?)
}

protocol PushDelegate : AnyObject {
    func pushScreen(_ VC: UIViewController)
}

class MyInfoView: UIView{
    static let shared = MyInfoView()
    let request = ServerRequest.shared
    
    weak var delegate : MyInfoViewDelegate?
    weak var pushDelegate : PushDelegate?
    
    // MARK: - Injection
    let viewModel = MyInfoViewModel()
    
    // MARK: - Properties
    private var userInfo: UserInfo? {
        didSet {
            print("MyInfoView userInfo =>\n\(userInfo)")
            self.delegate?.parameter(userInfo)
        }
    }
    
    var requestDic = Dictionary<String, Any>()
    
//    let UserInfo = UserDefaults.standard.dictionary(forKey: "UserInfo")
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let view1 = UIView()
    let profileview = UIView()
    let profileImg : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 27.5
        view.image = UIImage(named: "NonProfile")
        view.tintColor = UIColor.grayColor205
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    let socialBadge : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
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
    let followerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        return view
    }()
    let followerCount : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .boldSystemFont(ofSize: 16)
        UILabel.textAlignment = .center
        UILabel.textColor = .black
        return UILabel
    }()
    let followerLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .systemFont(ofSize: 15)
        UILabel.text = "팔로워"
        UILabel.textAlignment = .center
        UILabel.textColor = .black
        return UILabel
    }()
    let followingView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        return view
    }()
    let followingCount : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .boldSystemFont(ofSize: 16)
        UILabel.textAlignment = .center
        UILabel.textColor = .black
        return UILabel
    }()
    let followingLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .systemFont(ofSize: 15)
        UILabel.text = "팔로잉"
        UILabel.textAlignment = .center
        UILabel.textColor = .black
        return UILabel
    }()
    let introductView : UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        view.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        return view
    }()
    let introductLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .systemFont(ofSize: 15)
        UILabel.textColor = .systemPink
        UILabel.textAlignment = .center
        UILabel.numberOfLines = 0
        return UILabel
    }()
    let view2 = UIView()
    let view3 = UIView()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView) // 메인뷰에
        backgroundColor = UIColor.BackgroundColor
        
        print(#file , #function)
        
        _ = [view1, view2, view3].map { self.contentView.addSubview($0)}
        scrollView.addSubview(contentView)
        view1.addSubview(profileview)
        
        view1.addSubview(nickName)
        view1.addSubview(major)
        view1.addSubview(followerView)
        view1.addSubview(followingView)
        view1.addSubview(introductView)
        
        profileview.addSubview(socialBadge)
        profileview.addSubview(profileImg)
        
        self.profileview.bringSubviewToFront(self.socialBadge)
        
        followingView.addSubview(followingCount)
        followingView.addSubview(followingLabel)
        
        followerView.addSubview(followerCount)
        followerView.addSubview(followerLabel)
        
        introductView.addSubview(introductLabel)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview() // 스크롤뷰가 표현될 영역
        }
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        view2.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.black.cgColor
        
        view3.layer.borderWidth = 1
        view3.layer.borderColor = UIColor.black.cgColor
        
        
        view1.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview()
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(300)
        }
        
        profileview.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalToSuperview()
            make.width.height.equalTo(55)
        }
        
        profileImg.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(55)
        }
        
        socialBadge.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.right.top.equalToSuperview()
        }
        
        nickName.snp.makeConstraints { (make) in
            make.bottom.equalTo(profileImg.snp.centerY).offset(-1)
            make.left.equalTo(profileImg.snp.right).offset(10)
            make.right.equalTo(followerView.snp.left)
        }
        
        major.snp.makeConstraints { (make) in
            make.top.equalTo(profileImg.snp.centerY).offset(2)
            make.left.equalTo(profileImg.snp.right).offset(10)
        }
        
        followerView.snp.makeConstraints { (make) in
            make.width.height.equalTo(profileImg.snp.width)
            make.right.equalTo(followingView.snp.left).offset(-20)
            make.centerY.equalTo(profileImg.snp.centerY)
        }
        
        followerLabel.snp.makeConstraints { (make) in
            
            make.right.equalTo(followerView.snp.right).offset(-5)
            make.left.equalTo(followerView.snp.left).offset(5)
            make.bottom.equalTo(followerView.snp.bottom).offset(-5)
        }
        
        followerCount.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(followerView.snp.top).offset(5)
        }
        
        followingView.snp.makeConstraints { (make) in
            make.width.height.equalTo(profileImg.snp.width)
            make.right.equalToSuperview()
            make.centerY.equalTo(profileImg.snp.centerY)
        }
        
        followingLabel.snp.makeConstraints { (make) in
            
            make.right.equalTo(followingView.snp.right).offset(-5)
            make.left.equalTo(followingView.snp.left).offset(5)
            make.bottom.equalTo(followingView.snp.bottom).offset(-5)
        }
        
        followingCount.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(followingView.snp.top).offset(5)
        }
        
        introductView.snp.makeConstraints{(make) in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(followingView.snp.bottom).offset(30)
            make.height.equalTo(160)
        }
        
        introductLabel.snp.makeConstraints{(make) in
            
            make.top.left.equalTo(20)
            make.bottom.right.equalTo(-20)
        }
        
        view2.snp.makeConstraints { (make) in

            make.top.equalTo(view1.snp.bottom).offset(30)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalToSuperview()
        }
        
        requestMyInfo()
    }
    
    func requestMyInfo(){
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo") {
            let socialType = value["socialType"] as? String
            print("socialType", socialType)
            
            switch socialType {
            case "KAKAO":
                socialBadge.image = UIImage(named: "kakao")
            case "APPLE":
                socialBadge.image = UIImage(named: "apple")
            case "NAVER":
                socialBadge.image = UIImage(named: "naver")
            case "GOOGLE":
                socialBadge.image = UIImage(named: "google")
            default:
                print("default")
            }
            
            viewModel.getUserInfo()
            
            viewModel.didFinishFetch = {
                self.userInfo = self.viewModel.userInfo
                
                if let profile = self.viewModel.profileImgURLString {
                    print("self.viewModel.profileImgURLString", self.viewModel.profileImgURLString)
                    //url에 정확한 이미지 url 주소를 넣는다.
                    let url = URL(string: profile)
                    //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
                    //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        DispatchQueue.main.async {
        //                    cell.imageView.image = UIImage(data: data!)
                            self.profileImg.kf.indicatorType = .activity
                            self.profileImg.kf.setImage(
                              with: url,
                              placeholder: nil,
                              options: [.transition(.fade(1.2))],
                              completionHandler: nil
                            )
                        }
                    }
                }else {
                    self.profileImg.image = UIImage(named: "NonProfile")
                }
                
                
                self.nickName.text = self.viewModel.nicknameString
                self.major.text = self.viewModel.major2String
                self.followerCount.text = self.viewModel.followerString
                self.followingCount.text = self.viewModel.followingString
                self.introductLabel.text = self.viewModel.introduceString
            }
        }else {
            print(#file , "\(#function) else")
        }
        
    }
    
    @objc func btnAction(_ sender: Any){
        self.pushDelegate?.pushScreen(UpdateMyInfoViewController.shared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
