//
//  UpdateMyInfoViewModel.swift
//  Summar
//
//  Created by plsystems on 2023/01/12.
//

import Foundation

final class UpdateMyInfoViewModel{
    private var request = ServerRequest.shared
    
    var serverResult: ServerResult? {
        didSet {
            self.didFinishFetch?()
        }
    }
    var param: Dictionary<String, Any>?
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
    func updateUserInfo(_ param: Dictionary<String, Any>) {
        self.request.updateUserInfo("/user/user-info", param, completion: { (result, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                print("updateUserInfo() if let error")
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.updateUserInfo(param)
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
            self.serverResult = result
            
        })
    }
}
