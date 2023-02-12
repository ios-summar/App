//
//  ToastHelper.swift
//  Summar
//
//  Created by ukBook on 2023/02/12.
//

import Foundation
import UIKit

internal func toast(_ message: String) {
    UIApplication.shared.keyWindow?.rootViewController?.view.makeToast(message, duration: 1.5, position: .center)
}
