//
//  MyInfoView.swift
//  Summar
//
//  Created by mac on 2022/12/14.
// https://hryang.tistory.com/7 => scrollview programmatically

import Foundation
import UIKit

class MyInfoView: UIView{
    static let shared = MyInfoView()
    let UserInfo = UserDefaults.standard.dictionary(forKey: "UserInfo")
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let view1 = UIView()
    let profileImg : UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 27.5
        view.image = UIImage(systemName: "person.fill")
        view.contentMode = .scaleAspectFit
        return view
    }()
    let nickName : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.sizeToFit()
        label.text = ""
        return label
    }()
    let major : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.sizeToFit()
        label.text=""
        return label
    }()
    let followerView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    let followerCount : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .boldSystemFont(ofSize: 16)
        UILabel.layer.borderWidth = 1
        UILabel.layer.borderColor = UIColor.black.cgColor
        UILabel.textAlignment = .center
        UILabel.text = "10K"
        return UILabel
    }()
    let followerLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .systemFont(ofSize: 15)
        UILabel.text = "팔로워"
        UILabel.layer.borderWidth = 1
        UILabel.layer.borderColor = UIColor.black.cgColor
        UILabel.textAlignment = .center
        return UILabel
    }()
    let followingView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    let followingCount : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .boldSystemFont(ofSize: 16)
        UILabel.layer.borderWidth = 1
        UILabel.layer.borderColor = UIColor.black.cgColor
        UILabel.textAlignment = .center
        UILabel.text = "10K"
        return UILabel
    }()
    let followingLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .systemFont(ofSize: 15)
        UILabel.text = "팔로잉"
        UILabel.layer.borderWidth = 1
        UILabel.layer.borderColor = UIColor.black.cgColor
        UILabel.textAlignment = .center
        return UILabel
    }()
    let view2 = UIView()
    let view3 = UIView()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView) // 메인뷰에
        _ = [view1, view2, view3].map { self.contentView.addSubview($0)}
        scrollView.addSubview(contentView)
        view1.addSubview(profileImg)
        view1.addSubview(nickName)
        view1.addSubview(major)
        view1.addSubview(followerView)
        view1.addSubview(followingView)
        
        followingView.addSubview(followingCount)
        followingView.addSubview(followingLabel)
        
        followerView.addSubview(followerCount)
        followerView.addSubview(followerLabel)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview() // 스크롤뷰가 표현될 영역
        }
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor.black.cgColor
        
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
        
        profileImg.snp.makeConstraints { (make) in
            make.top.equalTo(20)
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
        
        view2.snp.makeConstraints { (make) in
            
            make.top.equalTo(view1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        view3.snp.makeConstraints { (make) in
            
            make.top.equalTo(view2.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview() // 이것이 중요함
        }
        
        profileInit()
    }
    
    func profileInit(){
        if let value = UserInfo {
            let UserInfoNickName = value["userNickname"] as! String
            let UserInfoMajor1 = value["major1"] as! String
            let UserInfoMajor2 = value["major2"] as! String
            
            nickName.text = UserInfoNickName
            major.text = UserInfoMajor2
        }else {
            nickName.text = "정보 가져오기 실패"
            major.text = "다시 로그인 해주세요"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
