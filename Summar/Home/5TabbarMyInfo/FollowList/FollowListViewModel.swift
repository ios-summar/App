//
//  FollowListViewModel.swift
//  Summar
//
//  Created by plsystems on 2023/02/06.
//

import Foundation

final class FollowListViewModel {
    private var request = ServerRequest.shared
    
    var pageIndex: Int? = nil
    var size: Int? = nil
    
    init(_ pageIndex: Int?, _ size: Int?){
        self.pageIndex = pageIndex
        self.size = size
        
        print("pageIndex : \(pageIndex), size : \(size)")
    }
    
    var followerList: SearchUserList? {
        didSet {
            smLog("\(followerList)")
            guard let p = followerList else { return }
            self.setupTextFollower(with: p)
            self.didFinishFollowerListFetch?()
        }
    }
    
    var followingList: SearchUserList? {
        didSet {
            smLog("\(followingList)")
            guard let p = followingList else { return }
            self.setupTextFollowing(with: p)
            self.didFinishFollowingListFetch?()
        }
    }
    
    var didFinishFollowerListFetch: (() -> ())?
    var didFinishFollowingListFetch: (() -> ())?
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    
    var followerTotalRecordCountString: String?
    var followingTotalRecordCountString: String?
    
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    // MARK: - Network call
    func getFollowerList(_ userSeq: Int) {
        self.request.followList("/follow/followers?userSeq=\(userSeq)&page=\(pageIndex)&size=\(size)", completion: { (followList, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 500 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.getFollowerList(userSeq)
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.followerList = followList
        })
    }
    
    // MARK: - Network call
    func getFollowingList(_ userSeq: Int) {
        self.request.followList("/follow/followings?userSeq=\(userSeq)&page=\(pageIndex)&size=\(size)", completion: { (followList, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 500 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.getFollowingList(userSeq)
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.followingList = followList
        })
    }
    
    // MARK: - UI Logic
    private func setupTextFollower(with follower: SearchUserList?) {
        if let totalRecordCount = follower?.totalRecordCount {
            self.followerTotalRecordCountString = "\(String(totalRecordCount)) 팔로워"
            smLog("\(followerTotalRecordCountString)")
        }
    }
    
    // MARK: - UI Logic
    private func setupTextFollowing(with following: SearchUserList?) {
        if let totalRecordCount = following?.totalRecordCount {
            self.followingTotalRecordCountString = "\(String(totalRecordCount)) 팔로잉"
            smLog("\(followingTotalRecordCountString)")
        }
    }
}
