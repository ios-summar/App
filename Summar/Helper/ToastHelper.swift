//
//  ToastHelper.swift
//  Summar
//
//  Created by ukBook on 2023/02/12.
//

import Foundation
import UIKit
import Toast_Swift

internal func toast(_ message: String) {
    
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        let keyWindow = scene.windows.first(where: { $0.isKeyWindow })
        
        keyWindow?.rootViewController?.view.makeToast(message, duration: 1.5, position: .center)
    }
}
