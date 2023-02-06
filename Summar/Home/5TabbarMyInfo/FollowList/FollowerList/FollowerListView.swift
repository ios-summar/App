//
//  FollowListView.swift
//  Summar
//
//  Created by plsystems on 2023/02/06.
//

import Foundation
import UIKit

final class FollowerListView: UIView, ViewAttributes {
    weak var delegate: PushDelegate?
    let helper = Helper()
    var userSeq: Int?
    
    var followerList: SearchUserList? {
        didSet {
            smLog("\(followerList)")
            self.followerTableView.reloadData()
        }
    }
    
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
        UILabel.text = "팔로워가 없어요"
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
        addSubview(followerTableView)
        addSubview(noImage)
        addSubview(noLabel)
    }
    
    func setAttributes() {
        followerTableView.snp.makeConstraints {
            $0.left.right.bottom.top.equalTo(self.safeAreaLayoutGuide)
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
    
    
    func followerExist(_ handler: Bool) {
        smLog("\(handler)")
        followerTableView.alpha = 0.0
        noImage.alpha = 0.0
        noLabel.alpha = 0.0
        
        //카운트후 alpha값 변경
        if handler {
            followerTableView.alpha = 1.0
        }else {
            noImage.alpha = 1.0
            noLabel.alpha = 1.0
        }
    }
    
    /// 서버통신
    func getFollowerList(_ userSeq: Int?) {
        guard let userSeq = userSeq else { return }
        smLog("\(userSeq)")
        let viewModel = FollowListViewModel(0, 2000)
        
        //팔로워
        viewModel.getFollowerList(userSeq)
        viewModel.didFinishFollowerListFetch = {
            self.followerList = viewModel.followerList
            guard let totalRecordCount = viewModel.followerTotalRecordCountString else { return }
            
            if self.followerList?.totalRecordCount! != 0 {
                self.followerExist(true)
            }else {
                self.followerExist(false)
            }
        }
    }
    
    /// 서버통신
    //    func getFollowingList(_ userSeq: Int?) {
    //        guard let userSeq = userSeq else { return }
    //        smLog("\(userSeq)")
    //        let viewModel = FollowListViewModel(0, 30)
    //
    //        //팔로잉
    //        viewModel.getFollowingList(userSeq)
    //        viewModel.didFinishFollowingListFetch = {
    //            self.followingList = viewModel.followingList
    //            guard let totalRecordCount = viewModel.followingTotalRecordCountString else { return }
    //
    //            if self.followingList?.totalRecordCount! != 0 {
    //                self.followingExist(true)
    //            }else {
    //                self.followingExist(false)
    //            }
    //        }
    //    }
}

extension FollowerListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let followerListCount = followerList?.content?.count else {return 0}
        return followerListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowListTableViewCell", for: indexPath) as! FollowListTableViewCell
        guard let follower = followerList?.content?[indexPath.row] else {return UITableViewCell()}
        cell.setUpCell(follower, "follower")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let follower = followerList?.content?[indexPath.row] else {return}
        let VC = ProfileViewController()
        
        self.delegate?.pushScreen(VC, follower.userSeq)
        
    }
}
