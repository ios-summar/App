//
//  SearchViewModel.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import Foundation

class SearchViewModel: reCallDelegate{
    private var request = ServerRequest.shared
    
    var nickname: String? = nil
    var pageIndex: Int? = nil
    var size: Int? = nil
    
    init(_ nickname: String? = nil, _ pageIndex: Int?, _ size: Int?){
        self.nickname = nickname
        self.pageIndex = pageIndex
        self.size = size
    }
    
    private var searchUserList : SearchUserList? {
        didSet {
            print("searchUserInfo => \(searchUserList)")
            print(#file , #function)
            guard let p = searchUserList else { return }
            self.setupText(with: p)
            self.didFinishFetch?()
        }
    }
    
    var empty: Bool?
    var nicknameString: String?
    var major2String: String?
    var follow: String?
    var introduceString: String?
//    var profileImg: URL?
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    func recallFunc(_ function: String?) {
        print("function => \(function)")
    }
    
    public init() {
        request.reCalldelegate = self
    }
    
    func serachNickname(){
        print("---------------")
        print(nickname)
        print(pageIndex)
        print(size)
        print("---------------")
        guard let nickname = nickname else {return}
        guard let pageIndex = pageIndex else {return}
        guard let size = size else {return}
        
        self.request.searchNickname("/user/search-user-list?userNickname=\(nickname)&page=\(pageIndex)&size=\(size)", completion: { (searchUserList, error) in
            if let error = error {
                print(error)
//                self.error = error
//                self.isLoading = false
                return
            }
//            self.error = nil
//            self.isLoading = false
            self.searchUserList = searchUserList
        })
    }
    
    // MARK: - UI Logic 프로필이미지, 닉네임, 전공, 팔로워
    private func setupText(with searchUserList: SearchUserList) {
        print(#file , #function)
        if searchUserList.totalPageCount == 0 {
            self.empty = true
        }else {
            self.empty = false
        }
        
//        if let nickname = userInfo.result.userNickname {
//            self.nicknameString = nickname
//        }
//        if let major2 = userInfo.result.major2 {
//            self.major2String = major2
//        }
//        if let follower = userInfo.result.follower {
//            self.followerInt = follower
//        }
//        if let following = userInfo.result.following {
//            self.followingInt = following
//        }
//        if let introduce = userInfo.result.introduce {
//            self.introduceString = introduce
//        }else {
//            self.introduceString = "작성된 자기소개가 없습니다. 😥\n자기소개를 작성해 자신을 소개해보세요."
//        }
    }
}
