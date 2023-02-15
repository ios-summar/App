//
//  ReportViewModel.swift
//  Summar
//
//  Created by ukBook on 2023/02/12.
//

import Foundation

final class ReportViewModel{
    private var request = ServerRequest.shared
    
    // MARK: - Properties
//    let myInfo = UserDefaults.standard.dictionary(forKey: "UserInfo")
    
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
    
    // MARK: - Network call
    func report(_ param: Dictionary<String, Any>) {
        smLog("\(param)")
        self.request.report("/report", param, completion: { (result, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.report(param)
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            guard let result = result else {return}
            self.error = nil
            self.isLoading = false
            
            if result {
                self.didFinishFetch?()
            }
        })
    }
    
    // MARK: - UI Logic
    private func setupText(with userInfo: UserInfo) {
        smLog("")
        print("userInfo", userInfo)
        self.profileImgURLString = nil
        
        if let nickname = userInfo.result.userNickname {
            self.nicknameString = nickname
        }
        if let profileImgURL = userInfo.result.profileImageUrl {
            self.profileImgURLString = profileImgURL
        }
        if let major2 = userInfo.result.major2 {
            self.major2String = major2
        }
        if let follower = userInfo.result.follower {
            self.followerString = follower.commaRepresentation
        }
        if let following = userInfo.result.following {
            self.followingString = following.commaRepresentation
        }
        if let introduce = userInfo.result.introduce {
            self.introduceString = introduce
        }else {
            self.introduceString = "작성된 자기소개가 없습니다."
        }
    }
    
}
