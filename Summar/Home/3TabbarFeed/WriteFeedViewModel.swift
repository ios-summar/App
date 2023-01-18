//
//  WriteFeedViewModel.swift
//  Summar
//
//  Created by ukBook on 2023/01/18.
//

import Foundation
import UIKit

class WriteFeedViewModel {
    private var request = ServerRequest.shared
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    func insertFeed(_ param: Dictionary<String, Any>, _ imageArr: [UIImage]){
        smLog("\n \(param)")
        self.request.insertFeed("/feed", param, imageArr, completion: { (feedInsertResponse, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 500 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.insertFeed(param, imageArr)
                }
            }else if let error = error {
                print(error)
//                self.error = error
//                self.isLoading = false
                return
            }
//            self.error = nil
//            self.isLoading = false
            self.didFinishFetch?()
        })
    }
}
