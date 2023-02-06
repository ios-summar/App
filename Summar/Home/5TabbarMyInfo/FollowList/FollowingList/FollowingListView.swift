//
//  FollowingListView.swift
//  Summar
//
//  Created by plsystems on 2023/02/06.
//

import Foundation
import UIKit

final class FollowingListView: UIView, ViewAttributes {
    weak var delegate: PushDelegate?
    let helper = Helper()
    var userSeq: Int?
    
    var followingList: SearchUserList? {
        didSet {
            smLog("\(followingList)")
            self.followingTableView.reloadData()
        }
    }
    
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
        UILabel.text = "팔로우 중인 사람이 없어요"
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
        addSubview(followingTableView)
        addSubview(noImage)
        addSubview(noLabel)
    }
    
    func setAttributes() {
        followingTableView.snp.makeConstraints {
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
    
    func followingExist(_ handler: Bool) {
        smLog("\(handler)")
        followingTableView.alpha = 0.0
        noImage.alpha = 0.0
        noLabel.alpha = 0.0
        
        //카운트후 alpha값 변경
        if handler {
            followingTableView.alpha = 1.0
        }else {
            noImage.alpha = 1.0
            noLabel.alpha = 1.0
        }
    }
    
    /// 서버통신
    func getFollowingList(_ userSeq: Int?) {
        guard let userSeq = userSeq else { return }
        smLog("\(userSeq)")
        let viewModel = FollowListViewModel(0, 2000)
        
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

extension FollowingListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let followingCount = followingList?.content?.count else {return 0}
        return followingCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowListTableViewCell", for: indexPath) as! FollowListTableViewCell
        guard let following = followingList?.content?[indexPath.row] else {return UITableViewCell()}
        cell.setUpCell(following, "following")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let following = followingList?.content?[indexPath.row] else {return}
        self.delegate?.pushScreen(ProfileViewController.shared, following.userSeq)
    }
}
