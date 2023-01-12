//
//  UpdateMyInfoViewModel.swift
//  Summar
//
//  Created by plsystems on 2023/01/12.
//

import Foundation

//class UpdateMyInfoViewModel{
//    private var request = ServerRequest.shared
//    
//    var userInfo: UserInfo? {
//        didSet {
//            print("PreferencesViewModel userInfo =>\n \(userInfo)")
//            guard let p = userInfo else { return }
//            self.setupText(with: p)
//            self.didFinishFetch?()
//        }
//    }
//    var param: Dictionary<String, Any>?
//    var error: Error? {
//        didSet { self.showAlertClosure?() }
//    }
//    var isLoading: Bool = false {
//        didSet { self.updateLoadingStatus?() }
//    }
//    
//    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
//    var showAlertClosure: (() -> ())?
//    var updateLoadingStatus: (() -> ())?
//    var didFinishFetch: (() -> ())?
//    
//    // MARK: - Network call
//    func getUserInfo() {
//        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo") {
//            print("myInfo => \(value)")
//            let userId = value["userEmail"] as! String
//            self.request.requestMyInfo("/user/user-info?userEmail=\(userId)", completion: { (userInfo, error, status) in
//                //error만 있을경우 서버오류
//                //error,status != nil 경우 토큰 재발급
//                if let error = error, let status = status {
//                    print("getUserInfo() iflet error")
//                    self.request.reloadToken(status)
//                    self.getUserInfo()
//                }else if let error = error {
//                    print(error)
//                    self.error = error
//                    self.isLoading = false
//                    return
//                }
//                self.error = nil
//                self.isLoading = false
//                self.userInfo = userInfo
//                
//            })
//        }
//    }
//    
//    // MARK: - UI Logic
//    private func setupText(with userInfo: UserInfo) {
//        smLog("")
//        print("userInfo", userInfo)
//        if let nickname = userInfo.result.userNickname {
//            self.nicknameString = nickname
//        }
//        if let profileImgURL = userInfo.result.profileImageUrl {
//            self.profileImgURLString = profileImgURL
//        }
//        if let major2 = userInfo.result.major2 {
//            self.major2String = major2
//        }
//    }
//    
//}
