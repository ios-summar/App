//
//  NoticeViewModel.swift
//  Summar
//
//  Created by ukBook on 2023/01/15.
//

import Foundation

class NoticeViewModel {
    private var request = ServerRequest.shared
    
    var notice : Notice? {
        didSet {
            self.didFinishFetch?()
        }
    }
    
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    // MARK: - Network call
    func getNotice() {
        self.request.notice("/setting?status=notice", completion: { (result, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                print("getNotice() if let error")
                self.request.reloadToken(status)
                self.getNotice()
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.notice = result
        })
    }
}
