//
//  NotificationViewModel.swift
//  Summar
//
//  Created by ukBook on 2023/02/19.
//

import Foundation

final class NotificationViewModel {
    private var request = ServerRequest.shared
    
    var model: NotificationModel? {
        didSet {
            self.didFinishFetch?()
        }
    }
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    func getNotiList(){
        let userSeq = getMyUserSeq()
        self.request.notificationList("/notification/list?userSeq=\(userSeq)", completion: { (result, error, status) in
            //error만 있을경우 서버오류
            //error,status != nil 경우 토큰 재발급
            if let error = error, let status = status {
                if status == 401 {
                    print("토큰 재발급")
                    self.request.reloadToken(status)
                    self.getNotiList()
                }
            }else if let error = error {
                print(error)
//                self.error = error
//                self.isLoading = false
                return
            }
//            self.error = nil
//            self.isLoading = false
            self.model = result
        })
    }
    
}
