//
//  AppleLoginManager.swift
//  Summar
//
//  Created by mac on 2022/11/07.
//

import Foundation
import AuthenticationServices

class AppleLoginManager : NSObject{
    weak var viewController: UIViewController?
//    weak var delegate: AppleLoginManagerDelegate?
    
    func setAppleLoginPresentationAnchorView(_ view: UIViewController) {
        self.viewController = view
    }
}

extension AppleLoginManager : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController!.view.window!
    }
}
