//
//  ClippingViewModel.swift
//  Summar
//
//  Created by plsystems on 2023/02/08.
//

import Foundation

final class ClippingViewModel {
    private var request = ServerRequest.shared
    
    var feedSelectResponse: FeedSelectResponse? {
        didSet {
            smLog("\n \(self.feedSelectResponse?.content?.count)")
            self.didFinishFetch?()
        }
    }
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    func scrapFeed(pageIndex: Int, size: Int){
        self.request.scrapFeed("/feed/scrap?page=\(pageIndex)&size=\(size)", completion: { (feedSelectResponse, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.scrapFeed(pageIndex: pageIndex, size: size)
                }else if status == 500 {
                    toast("서버 오류, 잠시후 다시 시도해주세요.")
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
                }else if status == 500 {
                    toast("서버 오류, 잠시후 다시 시도해주세요.")
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
                self.didFinishFetch?()
            }
        })
    }
    
}
