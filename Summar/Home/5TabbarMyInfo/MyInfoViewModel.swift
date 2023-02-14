//
//  TabbarMyInfoViewModel.swift
//  Summar
//
//  Created by ukBook on 2022/12/19.
//

import Foundation
import Alamofire

final class MyInfoViewModel{
    private var request = ServerRequest.shared
    
    // MARK: - Properties
//    let myInfo = UserDefaults.standard.dictionary(forKey: "UserInfo")
    
    var followResult: Bool? {
        didSet {
            self.didFinishFollowCheckFetch?()
        }
    }
    
    var pageIndex: Int? = nil
    var size: Int? = nil
    
    init(_ pageIndex: Int?, _ size: Int?){
        self.pageIndex = pageIndex
        self.size = size
        
        print("pageIndex : \(pageIndex), size : \(size) ")
    }
    
    var userInfo: UserInfo? {
        didSet {
            print("MyInfoViewModel userInfo =>\n \(userInfo)")
            guard let p = userInfo else { return }
            self.setupText(with: p)
            self.didFinishFetch?()
        }
    }
    var feedSelectResponse: FeedSelectResponse? {
        didSet {
            print("MyInfoViewModel feedSelectResponse =>\n \(feedSelectResponse)")
            self.didFinishPortfolioFetch?()
        }
    }
    
    var temporaryResponse: FeedSelectResponse? {
        didSet {
            print("MyInfoViewModel temporaryResponse =>\n \(temporaryResponse)")
            self.didFinishTemporarySaveFetch?()
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
    var didFinishFollowCheckFetch: (() -> ())?
    var didFinishFollowFetch: (() -> ())?
    var didFinishPortfolioFetch: (() -> ())?
    var didFinishTemporarySaveFetch: (() -> ())?
    
    // MARK: - Network call
    func getUserInfo(_ userSeq: Int) {
        self.request.requestMyInfo("/user/user-info?userSeq=\(userSeq)", completion: { (userInfo, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
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
    
    // MARK: - Network call
    func followCheck(_ followedUserSeq: Int, _ followingUserSeq: Int) {
        self.request.followCheck("/follow/follow-check?followedUserSeq=\(followedUserSeq)&followingUserSeq=\(followingUserSeq)", completion: { (result, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 500 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.followCheck(followedUserSeq, followingUserSeq)
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.followResult = result
        })
    }
    
    // MARK: - Network call
    func followAction(_ param: Dictionary<String, Int>, _ httpMethod: String) {
        self.request.followAction("/follow/follower", param, httpMethod,  completion: { (result, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 500 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.followAction(param, httpMethod)
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            
            result != nil ? self.didFinishFollowFetch?() : nil
        })
    }
    
    // MARK: - 포트폴리오
    /// 포트폴리오
    func getPortfolio(_ userSeq: Int) {
        self.request.requestMyFeed("/feed/user/\(userSeq)?page=0&size=100000", completion: { (feedSelectResponse, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
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
            self.feedSelectResponse = feedSelectResponse
            
        })
    }
    
    // MARK: - 임시저장
    /// 임시저장
    func getTemporarySave() {
        guard let pageIndex = pageIndex, let size = size else {return}
        let userSeq = getMyUserSeq()
        self.request.requestMyFeed("/feed/temp/\(userSeq)/?page=\(pageIndex)&size=\(size)", completion: { (feedSelectResponse, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 500 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.getTemporarySave()
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            smLog("\(feedSelectResponse)")
            
            self.error = nil
            self.isLoading = false
            self.temporaryResponse = feedSelectResponse
            
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
