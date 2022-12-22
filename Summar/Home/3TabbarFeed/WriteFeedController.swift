//
//  WriteFeed.swift
//  Summar
//
//  Created by mac on 2022/12/22.
//

import Foundation
import UIKit

class WriteFeedController : UIViewController, WriteFeedDelegate {
    func closAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    static let shared = WriteFeedController()
    let wfView = WriteFeedView.shared

    override func viewDidLoad() {
        wfView.delegate = self
        self.view.addSubview(wfView)
        
        
        wfView.snp.makeConstraints{(make) in
            make.edges.equalToSuperview()
        }
    }
}
