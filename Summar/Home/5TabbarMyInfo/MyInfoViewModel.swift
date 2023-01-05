//
//  TabbarMyInfoViewModel.swift
//  Summar
//
//  Created by ukBook on 2022/12/19.
//

import Foundation

class MyInfoViewModel: reCallDelegate{
    private var request = ServerRequest.shared
    
    func recallFunc(_ function: String?) {
        print("\(#file) function => \(function)")
        getUserInfo()
    }
    
    public init() {
        request.reCalldelegate = self
    }
    
    // MARK: - Properties
    let myInfo = UserDefaults.standard.dictionary(forKey: "UserInfo")
    
    
    private var userInfo: UserInfo? {
        didSet {
            print(#file , #function)
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
    var followerInt: Int?
    var followingInt: Int?
    var introduceString: String?
//    var profileImg: URL?
    
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    // MARK: - Network call
    func getUserInfo() {
        if let value = myInfo {
            print("myInfo => \(myInfo)")
            let userId = value["userEmail"] as! String
            self.request.requestMyInfo("/user/user-info?userEmail=\(userId)", completion: { (userInfo, error) in
                if let error = error {
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
    
    // MARK: - UI Logic
    private func setupText(with userInfo: UserInfo) {
        print(#file , #function)
        if let nickname = userInfo.result.userNickname {
            self.nicknameString = nickname
        }
        if let major2 = userInfo.result.major2 {
            self.major2String = major2
        }
        if let follower = userInfo.result.follower {
            self.followerInt = follower
        }
        if let following = userInfo.result.following {
            self.followingInt = following
        }
        if let introduce = userInfo.result.introduce {
            self.introduceString = introduce
        }else {
            self.introduceString = "작성된 자기소개가 없습니다. 😥\n자기소개를 작성해 자신을 소개해보세요."
        }
    }
    
}
