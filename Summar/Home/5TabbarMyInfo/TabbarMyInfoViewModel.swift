//
//  TabbarMyInfoViewModel.swift
//  Summar
//
//  Created by ukBook on 2022/12/19.
//

import Foundation

class TabbarMyInfoViewModel {
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
    
    
    private var request = ServerRequest.shared
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    // MARK: - Constructor
//    init(request: ServerRequest) {
//        self.request = request
//    }
    
    // MARK: - Network call
    func getUserInfo(withId userId: String) {
        if let value = myInfo {
            print("myInfo => \(myInfo)")
            let userId = value["userEmail"] as! String
//            self.request.requestMyInfo("/user/find-user?userEmail=\(userId)")
            self.request.requestMyInfo("/user/user-info?userEmail=\(userId)", completion: { (userInfo, error) in
                if let error = error {
                    print(error)
                    //                            self.error = error
                    //                            self.isLoading = false
                    return
                }
                print(" nil!!!!")
                print("userInfo => \(userInfo["result"])")
                //                        self.error = nil
                //                        self.isLoading = false
                //                        self.photo = photo
                let json : Dictionary<String, Any> = userInfo["result"] as! Dictionary<String, Any>
                
                print("json2 \(json["follower"])")
                print("json3 \(json["following"])")
                print("json4 \(json["introduce"])")
                print("json5 \(json["major1"])")
                print("json6 \(json["major2"])")
                print("json7 \(json["userNickname"])")
                
                
                let userNickname = json["userNickname"] as! String
                let major1 = json["major1"] as! String
                let major2 = json["major2"] as! String
                let socialType = value["socialType"] as! String
                let follower = json["follower"] as! Int
                let following = json["following"] as! Int
//                let introduce = json["introduce"] as! String
//                if let userNickname = json["userNickname"] ,let introduce = json["introduce"] {
//                    let introduce = introduce
//                }
                
                self.userInfo = UserInfo(userEmail: userId, userNickname: userNickname, major1: major1, major2: major2, socialType: socialType , follower: follower, following: following, introduce: "d")
                
            })
        }else {
            print(#file , "\(#function) else")
        }
    }
    
    // MARK: - UI Logic
    private func setupText(with userInfo: UserInfo) {
        if let userEmail = userInfo.userEmail, let userNickname = userInfo.userNickname, let major1 = userInfo.major1, let major2 = userInfo.major2, let socialType = userInfo.socialType, let follower = userInfo.follower, let following = userInfo.following, let introduce = userInfo.introduce {
//            print(userEmail)
//            print(socialType)
//            print(userNickname)
            self.userEmailString = userEmail
            self.nicknameString = userNickname
            self.major1String = major1
            self.major2String = major2
            self.socialTypeString = socialType
            self.followerInt = follower
            self.followingInt = following
            self.introduceString = introduce
        }
    }
    
}
