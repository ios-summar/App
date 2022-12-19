//
//  TabbarMyInfoViewModel.swift
//  Summar
//
//  Created by ukBook on 2022/12/19.
//

import Foundation

class TabbarMyInfoViewModel {
    // MARK: - Properties
    private var userInfo: UserInfo? {
        didSet {
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
    
    var titleString: String?
    var albumIdString: String?
    var photoUrl: URL?
    
    private var request: ServerRequest?
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    // MARK: - Constructor
    init(request: ServerRequest) {
        self.request = request
    }
    
    // MARK: - Network call
    func fetchPhoto(withId id: Int) {
        self.request?.requestMyInfo("/user/user-info?userEmail=2549549837", completion: { (json, error) in
            if let error = error {
                print("\(#line) error")
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
//            self.userInfo = json
            print("json => \(json)")
        })
    }
    
    // MARK: - UI Logic
    private func setupText(with userInfo: UserInfo) {
//        if let title = photo.title, let albumId = photo.albumID, let urlString = photo.url {
//            self.titleString = "Title: \(title)"
//            self.albumIdString = "Album ID for this photo : \(albumId)"
//
//            // formatting url from http to https
//            guard let formattedUrlString = String.replaceHttpToHttps(with: urlString), let url = URL(string: formattedUrlString) else {
//                return
//            }
//            self.photoUrl = url
//        }
        if let userEmail = userInfo.userEmail, let userNickname = userInfo.userNickname, let major1 = userInfo.major1, let major2 = userInfo.major2, let socialType = userInfo.socialType, let follower = userInfo.follower, let following = userInfo.following, let introduce = userInfo.introduce {
            
        }
    }
    
}
