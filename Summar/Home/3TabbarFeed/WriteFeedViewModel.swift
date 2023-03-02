//
//  WriteFeedViewModel.swift
//  Summar
//
//  Created by ukBook on 2023/01/18.
//

import Foundation
import UIKit

final class WriteFeedViewModel {
    private var request = ServerRequest.shared
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var didFinishUpdateFetch: (() -> ())?
    
    
    func insertFeed(_ param: Dictionary<String, Any>, _ imageArr: [UIImage]){
        smLog("\n \(param)")
        self.request.insertFeed("/feed", param, imageArr, completion: { (feedInsertResponse, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.insertFeed(param, imageArr)
                }else if status == 500 {
                    toast("서버 오류, 잠시후 다시 시도해주세요.")
                }
            }else if let error = error {
                print(error)
                return
            }
            self.didFinishFetch?()
        })
    }
    
    func updateFeed(_ param: Dictionary<String, Any>, _ imageArr: [UIImage], _ insertImage: Bool){
        smLog("param\n \(param)")
        smLog("insertImage\n \(insertImage)")
        guard let feedSeq = param["feedSeq"] as? Int else {toast("서버 오류, 잠시후 다시 시도해주세요."); return}
        self.request.updateFeed("/feed/\(feedSeq)", param, insertImage, imageArr, completion: { (feedInsertResponse, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.updateFeed(param, imageArr, insertImage)
                }else if status == 500 {
                    toast("서버 오류, 잠시후 다시 시도해주세요.")
                }
            }else if let error = error {
                print(error)
                return
            }
            self.didFinishUpdateFetch?()
        })
    }
}
