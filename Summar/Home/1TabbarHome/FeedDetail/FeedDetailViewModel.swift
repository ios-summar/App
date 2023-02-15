//
//  FeedDetailViewModel.swift
//  Summar
//
//  Created by ukBook on 2023/01/29.
//

import Foundation

final class FeedDetailViewModel {
    let request = ServerRequest()
    
    var feedInfo: FeedInfo? {
        didSet {
            print("FeedDetailViewModel feedInfo =>\n \(feedInfo)")
            guard let p = feedInfo else { return }
            self.setupText(with: p)
            self.didFinishFetch?()
        }
    }
    var feedComment: FeedComment? {
        didSet {
            print("feedComment didSet")
            self.didFinishFeedCommentFetch?()
        }
    }
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    var nicknameString: String?
    var major2String: String?
    var followerString: String?
    var followingString: String?
    var profileImgURLString: String?
    var feedImages: [FeedImages]?
    var secretYn: Bool?
    var commentYn: Bool?
    
    // 피드
    var contentString: String?
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var didFinishDelteFetch: (() -> ())?
    var didFinishFeedCommentFetch: (() -> ())?
    var didFinishCommentRegisterFetch: (() -> ())?
    var didFinishCommentRemoveFetch: (() -> ())?
    
    ///  피드 자세히보기
    func getFeedInfo(_ feedSeq: Int){
        self.request.feedInfo("/feed/\(feedSeq)", completion: { (feedInfo, error, status) in
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.getFeedInfo(feedSeq)
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.feedInfo = feedInfo

        })
    }
    
    ///  피드삭제
    func deleteFeed(_ feedSeq: Int){
        self.request.deleteFeed("/feed/\(feedSeq)", completion: { (feedInfo, error, status) in
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.deleteFeed(feedSeq)
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.didFinishDelteFetch?()
        })
    }
    
    
    ///  피드 자세히보기
    func getFeedComment(_ feedSeq: Int, _ size: Int){
        self.request.getFeedComment("/feed/\(feedSeq)/comments?page=0&size=\(size)", completion: { (feedComment, error, status) in
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.getFeedComment(feedSeq, size)
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.feedComment = feedComment

        })
    }
    
    ///  댓글 달기
    func commentRegister(_ param: Dictionary<String, Any>){
        let feedSeq = param["feedSeq"] as! Int
        self.request.commentRegister("/feed/\(feedSeq)/comments", param, completion: { (serverResult, error, status) in
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.commentRegister(param)
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            
            smLog("\(serverResult?.message)")
            if serverResult?.message == "정상처리" {
                self.didFinishCommentRegisterFetch?()
            }
            
        })
    }
    
    ///  댓글 삭제
    func commentRemove(_ feedCommentSeq: Int){
        self.request.commentRemove("/feed/comments/\(feedCommentSeq)", completion: { (serverResult, error, status) in
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.commentRemove(feedCommentSeq)
                }
            }else if let error = error {
                print(error)
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.didFinishCommentRemoveFetch?()
        })
    }
    
    
    // MARK: - UI Logic
    private func setupText(with feedInfo: FeedInfo) {
        if let nickname = feedInfo.user?.userNickname {
            self.nicknameString = nickname
        }
        if let profileImgURL = feedInfo.user?.profileImageUrl {
            self.profileImgURLString = profileImgURL
        }
        if let major2 = feedInfo.user?.major2, let createdDate = feedInfo.createdDate {
            self.major2String = "\(major2) / \(compareDate(createdDate))"
        }
        if let follower = feedInfo.user?.follower {
            self.followerString = follower.commaRepresentation
        }
        if let following = feedInfo.user?.following {
            self.followingString = following.commaRepresentation
        }
        
        //피드
        if let content = feedInfo.contents {
            self.contentString = content
        }
        
        // 댓글 사용 유무 및 비공개
        if let secretYn = feedInfo.secretYn {
            self.secretYn = secretYn
        }
        
        if let commentYn = feedInfo.commentYn {
            self.commentYn = commentYn
        }
    }
}
