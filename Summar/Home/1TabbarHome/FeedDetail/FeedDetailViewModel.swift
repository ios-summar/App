//
//  FeedDetailViewModel.swift
//  Summar
//
//  Created by ukBook on 2023/01/29.
//

import Foundation

class FeedDetailViewModel {
    let request = ServerRequest()
    
    var userInfo: UserInfo? {
        didSet {
            print("MyInfoViewModel userInfo =>\n \(userInfo)")
            guard let p = userInfo else { return }
            self.setupText(with: p)
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
    
    ///  피드 자세히보기(회원정보)
    func getUserInfo(_ userSeq: Int) {
        self.request.requestMyInfo("/user/user-info?userEmail=\(userSeq)", completion: { (userInfo, error, status) in
            if let error = error, let status = status {
                if status == 500 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.getUserInfo(userSeq)
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.userInfo = userInfo
            
        })
    }
    
    // MARK: - UI Logic
    private func setupText(with userInfo: UserInfo) {
        
    }
}
