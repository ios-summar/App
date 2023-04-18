//
//  BlockViewModel.swift
//  Summar
//
//  Created by ukBook on 2023/03/31.
//

import Foundation

final class BlockViewModel {
    private var request = ServerRequest.shared
    
    var info : [Info]? {
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
    func getBlockedUsers(completeHandler: @escaping ([Info]?) -> ()) {
        self.request.getBlockedUsers("/user/blocks", completion: { (userInfo, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.getBlockedUsers { value in
                        
                    }
                }else if status == 500 {
                    toast("서버 오류, 잠시후 다시 시도해주세요.")
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            
            completeHandler(userInfo)
        })
    }
    
    ///  사용자 차단 및 사용자 차단해제
    func blockUser(_ blockedUserSeq: Int, completionHandler: @escaping (Bool)->()){
        self.request.blockUser("/user/block/\(blockedUserSeq)", completion: { (result, error, status) in
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.blockUser(blockedUserSeq) { handler in
                        print("토큰 재발급 후 재요청")
                    }
                }else if status == 500 {
                    toast("서버 오류, 잠시후 다시 시도해주세요.")
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            
            completionHandler(true)
        })
    }
}
