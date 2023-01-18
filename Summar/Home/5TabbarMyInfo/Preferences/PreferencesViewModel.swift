//
//  PreferencesViewModel.swift
//  Summar
//
//  Created by plsystems on 2023/01/12.
//

import Foundation

class PreferencesViewModel{
    private var request = ServerRequest.shared
    
    // MARK: - Properties
    //    let myInfo = UserDefaults.standard.dictionary(forKey: "UserInfo")
    
    
    var userInfo: UserInfo? {
        didSet {
            print("PreferencesViewModel userInfo =>\n \(userInfo)")
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
    
    var userEmailString: String?
    var nicknameString: String?
    var major1String: String?
    var major2String: String?
    var socialTypeString: String?
    var followerString: String?
    var followingString: String?
    var introduceString: String?
    var profileImgURLString: String?
    
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var didFinishWithDraw: (() -> ())?
    
    // MARK: - Network call
    func getUserInfo() {
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo") {
            print("myInfo => \(value)")
            let userId = value["userEmail"] as! String
            self.request.requestMyInfo("/user/user-info?userEmail=\(userId)", completion: { (userInfo, error, status) in
                //error만 있을경우 서버오류
                //error,status != nil 경우 토큰 재발급
                if let error = error, let status = status {
                    if status == 500 {
                        print("토큰 재발급")
                        self.request.reloadToken(status)
                        self.getUserInfo()
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
    }
    
    func withDraw(_ userSeq: Int) {
        self.request.requestWithDraw("/user/leave?userSeq=\(userSeq)", completion: { (userInfo, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 500 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.withDraw(userSeq)
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.didFinishWithDraw?()
        })
    }
    
    // MARK: - UI Logic
    private func setupText(with userInfo: UserInfo) {
        smLog("")
        print("userInfo", userInfo)
        if let nickname = userInfo.result.userNickname {
            self.nicknameString = nickname
        }
        if let profileImgURL = userInfo.result.profileImageUrl {
            self.profileImgURLString = profileImgURL
        }
        if let major2 = userInfo.result.major2 {
            self.major2String = major2
        }
    }
    
}
