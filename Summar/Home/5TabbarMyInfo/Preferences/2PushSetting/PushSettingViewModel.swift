//
//  PushSettingViewModel.swift
//  Summar
//
//  Created by ukBook on 2023/01/14.
//

import Foundation

final class PushSettingViewModel {
    private var request = ServerRequest.shared
    
    // MARK: - Properties
//    let myInfo = UserDefaults.standard.dictionary(forKey: "UserInfo")
    
    var param : Dictionary<String, Any> = [:]
    
    var pushYn : Bool? {
        didSet {
            self.didFinishFetch?()
        }
    }
    
    var result: PushInfo? {
        didSet {
            smLog("")
            print(result)
            self.pushYn = result?.result.status
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
    func getPushYN() {
        let userSeq = getMyUserSeq()
        self.request.getPushYN("/user/push-notification-info?userSeq=\(userSeq)", completion: { (result, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.getPushYN()
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
            self.result = result
            
        })
    }
    
    // MARK: - Network call
    func changePushYN(_ statusBool: Bool) {
        if let userInfo = UserDefaults.standard.dictionary(forKey: "UserInfo") {
            guard let userNickname = userInfo["userNickname"] as? String else {return}
            param["status"] = statusBool
            param["userNickname"] = userNickname
            self.request.changePushYN("/user/push-notification-change",param ,completion: { (result, error, status) in
                //error만 있을경우 서버오류
                //error,status != nil 경우 토큰 재발급
                if let error = error, let status = status {
                    if status == 401 {
                        print("토큰 재발급")
                        self.request.reloadToken(status)
                        self.changePushYN(statusBool)
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
            })
        }
    }
}
