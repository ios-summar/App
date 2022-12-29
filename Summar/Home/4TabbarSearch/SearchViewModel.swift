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
    
    func recallFunc(_ function: String?) {
        print("function => \(function)")
    }
    
    public init() {
        request.reCalldelegate = self
    }
    
    func serachNickname(_ nickname: String){
        print(nickname)
    }
}
