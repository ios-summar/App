//
//  SearchViewModel.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import Foundation

class SearchViewModel: reCallDelegate{
    static let shared = SearchViewModel()
    private var request = ServerRequest.shared
    
    private var searchUserList : SearchUserList? {
        didSet {
            print("searchUserInfo => \(searchUserList)")
            
            searchUserList?.content
        }
    }
    
    func recallFunc(_ function: String?) {
        print("function => \(function)")
    }
    
    public init() {
        request.reCalldelegate = self
    }
    
    func serachNickname(_ nickname: String, _ pageIndex: Int, _ size: Int){
        print(nickname)
        
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
