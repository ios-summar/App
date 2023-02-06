//
//  FollowListView.swift
//  Summar
//
//  Created by plsystems on 2023/02/06.
//

import Foundation
import UIKit

final class FollowListView: UIView, ViewAttributes {
    weak var delegate: PushDelegate?
    let helper = Helper()
    var userSeq: Int?
    
    var followerList: SearchUserList? {
        didSet {
            smLog("\(followerList)")
            self.followerTableView.reloadData()
        }
    }
    
    var followingList: SearchUserList? {
        didSet {
            smLog("\(followingList)")
            self.followingTableView.reloadData()
        }
    }
    
    lazy var btnView = UIView()
    lazy var leftBtn : UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = FontManager.getFont(Font.Bold.rawValue).mediumFont
        button.backgroundColor = .white
        button.tag = 1
        button.addTarget(self, action: #selector(profileBtnAction(_:)), for: .touchUpInside)
        return button
    }()
    lazy var indicator : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    lazy var rightBtn : UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
        button.backgroundColor = .white
        button.tag = 2
        button.addTarget(self, action: #selector(profileBtnAction(_:)), for: .touchUpInside)
        return button
    }()
    let line2 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Gray02
        return view
    }()
    lazy var followerTableView: UITableView = {
        let view = UITableView()
        view.alpha = 1.0
        view.delegate = self
        view.dataSource = self
        view.register(FollowListTableViewCell.self, forCellReuseIdentifier: "FollowListTableViewCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false

        // 테이블뷰 왼쪽 마진 없애기
        view.separatorStyle = .none
        view.estimatedRowHeight = 130
        view.rowHeight = UITableView.automaticDimension
        view.tag = 1
        return view
    }()
    lazy var followingTableView: UITableView = {
        let view = UITableView()
        view.alpha = 0.0
        view.delegate = self
        view.dataSource = self
        view.register(FollowListTableViewCell.self, forCellReuseIdentifier: "FollowListTableViewCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false

        // 테이블뷰 왼쪽 마진 없애기
        view.separatorStyle = .none
        view.tag = 2
        return view
    }()
    lazy var noImage : UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.0
        imageView.image = UIImage(named: "NoCount")
        return imageView
    }()
    lazy var noLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.alpha = 0.0
        UILabel.textColor = .black
        UILabel.font = FontManager.getFont(Font.SemiBold.rawValue).mediumFont
        UILabel.sizeToFit()
        return UILabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        addSubview(btnView)
        btnView.addSubview(leftBtn)
        btnView.addSubview(rightBtn)
        btnView.addSubview(indicator)
        addSubview(line2)
        addSubview(followerTableView)
        addSubview(followingTableView)
        addSubview(noImage)
        addSubview(noLabel)
    }
    
    func setAttributes() {
        btnView.snp.makeConstraints {
            
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(44)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.centerX.equalToSuperview()
        }
        leftBtn.snp.makeConstraints {
            
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(44)
            $0.right.equalTo(self.btnView.snp.centerX)
            $0.left.equalToSuperview()
        }
        rightBtn.snp.makeConstraints {
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(44)
            $0.left.equalTo(self.btnView.snp.centerX)
            $0.right.equalToSuperview()
        }
        indicator.snp.makeConstraints {
            
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(2)
            $0.left.equalToSuperview()
            $0.right.equalTo(self.btnView.snp.centerX)
        }
        line2.snp.makeConstraints {
            
            $0.top.equalTo(btnView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(2)
        }
        followerTableView.snp.makeConstraints {
            $0.top.equalTo(line2.snp.bottom)
            $0.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        followingTableView.snp.makeConstraints {
            $0.top.equalTo(line2.snp.bottom)
            $0.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        noImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(80)
            $0.width.equalTo(215)
            $0.height.equalTo(194)
            $0.centerX.equalToSuperview()
        }
        noLabel.snp.makeConstraints {
            $0.top.equalTo(noImage.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func profileBtnAction(_ sender: Any) {
        guard let btn = sender as? UIButton else {return}
        switch btn.tag {
        case 1:
            touchLeft() // 팔로워
        case 2:
            touchRight() // 팔로잉
        default:
            print("default")
        }
    }
    
    func touchLeft(){
        leftBtn.titleLabel?.font = FontManager.getFont(Font.Bold.rawValue).mediumFont
        rightBtn.titleLabel?.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
        
        indicator.snp.remakeConstraints {
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(2)
            $0.left.equalToSuperview()
            $0.right.equalTo(self.btnView.snp.centerX)
        }

        getFollowerList(userSeq)
    }
    
    func touchRight(){
        rightBtn.titleLabel?.font = FontManager.getFont(Font.Bold.rawValue).mediumFont
        leftBtn.titleLabel?.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
        
        indicator.snp.remakeConstraints {
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(2)
            $0.right.equalToSuperview()
            $0.left.equalTo(self.btnView.snp.centerX)
        }

        getFollowingList(userSeq)
    }
    
    func followerExist(_ handler: Bool) {
        smLog("\(handler)")
        followerTableView.alpha = 0.0
        followingTableView.alpha = 0.0
        noImage.alpha = 0.0
        noLabel.alpha = 0.0
        noLabel.text = "팔로우"
        
        //카운트후 alpha값 변경
        if handler {
            followerTableView.alpha = 1.0
        }else {
            noImage.alpha = 1.0
            noLabel.alpha = 1.0
        }
    }
    
    func followingExist(_ handler: Bool) {
        smLog("\(handler)")
        followerTableView.alpha = 0.0
        followingTableView.alpha = 0.0
        noImage.alpha = 0.0
        noLabel.alpha = 0.0
        noLabel.text = "팔로잉"
        
        //카운트후 alpha값 변경
        if handler {
            followingTableView.alpha = 1.0
        }else {
            noImage.alpha = 1.0
            noLabel.alpha = 1.0
        }
    }
    
    /// 서버통신
    func getFollowerList(_ userSeq: Int?) {
        guard let userSeq = userSeq else { return }
        smLog("\(userSeq)")
        let viewModel = FollowListViewModel(0, 30)
        
        //팔로워
        viewModel.getFollowerList(userSeq)
        viewModel.didFinishFollowerListFetch = {
            self.followerList = viewModel.followerList
            guard let totalRecordCount = viewModel.followerTotalRecordCountString else { return }
            
            self.leftBtn.setTitle(totalRecordCount, for: .normal)
            if self.followerList?.totalRecordCount! != 0 {
                self.followerExist(true)
            }else {
                self.followerExist(false)
            }
        }
        
        //팔로잉
        viewModel.getFollowingList(userSeq)
        viewModel.didFinishFollowingListFetch = {
            self.followingList = viewModel.followingList
            guard let totalRecordCount = viewModel.followingTotalRecordCountString else { return }
            
            self.rightBtn.setTitle(totalRecordCount, for: .normal)
        }
    }
    
    /// 서버통신
    func getFollowingList(_ userSeq: Int?) {
        guard let userSeq = userSeq else { return }
        smLog("\(userSeq)")
        let viewModel = FollowListViewModel(0, 30)
        
        //팔로잉
        viewModel.getFollowingList(userSeq)
        viewModel.didFinishFollowingListFetch = {
            self.followingList = viewModel.followingList
            guard let totalRecordCount = viewModel.followingTotalRecordCountString else { return }
            
            if self.followingList?.totalRecordCount! != 0 {
                self.followingExist(true)
            }else {
                self.followingExist(false)
            }
        }
    }
}

extension FollowListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            guard let followerListCount = followerList?.content?.count else {return 0}
            return followerListCount
        }else if tableView.tag == 2 {
            guard let followingCount = followingList?.content?.count else {return 0}
            return followingCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowListTableViewCell", for: indexPath) as! FollowListTableViewCell
        if tableView.tag == 1 {
            guard let follower = followerList?.content?[indexPath.row] else {return UITableViewCell()}
            cell.setUpCell(follower, "follower")
            return cell
        }else if tableView.tag == 2 {
            guard let following = followingList?.content?[indexPath.row] else {return UITableViewCell()}
            cell.setUpCell(following, "following")
            return cell
        }else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            guard let follower = followerList?.content?[indexPath.row] else {return}
            self.delegate?.pushScreen(ProfileViewController.shared, follower.userSeq)
        }else if tableView.tag == 2 {
            guard let following = followingList?.content?[indexPath.row] else {return}
            self.delegate?.pushScreen(ProfileViewController.shared, following.userSeq)
        }
        
    }
}
