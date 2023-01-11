//
//  SearchViewModel.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import Foundation

class SearchViewModel{
    private var request = ServerRequest.shared
    
    var nickname: String? = nil
    var pageIndex: Int? = nil
    var size: Int? = nil
    
    init(_ nickname: String? = nil, _ pageIndex: Int?, _ size: Int?){
        self.nickname = nickname
        self.pageIndex = pageIndex
        self.size = size
    }
    
    var searchUserList : SearchUserList? {
        didSet {
            print("searchUserInfo => \(searchUserList)")
            print(#file , #function)
            guard let p = searchUserList else { return }
            self.setupText(with: p)
            self.didFinishFetch?()
        }
    }
    
    var empty: Bool?
    var searchUserInfo : [SearchUserInfo]? = nil
    
    var currentPageNo: Int? = nil
    var firstPage: Bool? = nil
    var lastPage: Bool? = nil
    var recordsPerPage: Int? = nil
    var totalPageCount: Int? = nil
    var totalRecordCount: Int? = nil
    
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    func searchNickname(){
        print("---------------")
        print(nickname)
        print(pageIndex)
        print(size)
        print("---------------")
        guard let nickname = nickname else {return}
        guard let pageIndex = pageIndex else {return}
        guard let size = size else {return}
        
        self.request.searchNickname("/user/search-user-list?userNickname=\(nickname)&page=\(pageIndex)&size=\(size)", completion: { (searchUserList, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                print("getUserInfo() iflet error")
                self.request.reloadToken(status)
                self.searchNickname()
            }else if let error = error {
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
        if searchUserList.totalPageCount == 0 {
            self.empty = true
        }else {
            self.empty = false
        }
    }
}
