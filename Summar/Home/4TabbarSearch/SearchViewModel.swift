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
//            self.setupText(with: p)
//            self.didFinishFetch?()
        }
    }
    
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
}
