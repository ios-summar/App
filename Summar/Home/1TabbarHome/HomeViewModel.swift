//
//  HomeViewModel.swift
//  Summar
//
//  Created by ukBook on 2023/01/18.
//

import Foundation
import UIKit

final class HomeViewModel {
    private var request = ServerRequest.shared
    
    var feedSelectResponse: FeedSelectResponse? {
        didSet {
            smLog("\n \(self.feedSelectResponse?.content?.count)")
            self.didFinishFetch?()
        }
    }
    
    var pageIndex: Int? = nil
    var size: Int? = nil
    
    init(_ pageIndex: Int?, _ size: Int?){
        self.pageIndex = pageIndex
        self.size = size
        
        print("pageIndex : \(pageIndex), size : \(size) ")
    }
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var didFinishLikeScrapFetch: (() -> ())?
    
    
    func selectFeed(){
        guard let pageIndex = pageIndex, let size = size else {return}
        self.request.selectFeed("/feed?page=\(pageIndex)&size=\(size)", completion: { (feedSelectResponse, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 401 {
                    smLog("토큰 재발급")
                    self.request.reloadToken(status)
                    self.selectFeed()
                }
            }else if let error = error {
                print(error)
//                self.error = error
//                self.isLoading = false
                return
            }
//            self.error = nil
//            self.isLoading = falses
            self.feedSelectResponse = feedSelectResponse
        })
    }
    
    func feedLikeScarp(_ handler: String, _ feedSeq: Int, _ param: Dictionary<String, Int>){
        self.request.feedLikeScarp("/feed/\(handler)/\(feedSeq)", param, completion: { (result, error, status) in
            guard let result = result?.result?.result else {return}
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.feedLikeScarp(handler, feedSeq, param)
                }
            }else if let error = error {
                print(error)
//                self.error = error
//                self.isLoading = false
                return
            }
//            self.error = nil
//            self.isLoading = falses
            if result {
                self.didFinishLikeScrapFetch?()
            }
        })
    }
    
}
