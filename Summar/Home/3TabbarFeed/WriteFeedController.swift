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
    let titleViewFeed = TitleWriteFeed()

    override func viewDidLoad() {
        titleViewFeed.delegate = self
        self.view.addSubview(titleViewFeed)
        self.view.addSubview(wfView)
        
        // MARK: - Feed 상단 타이틀, 버튼
        titleViewFeed.snp.makeConstraints{(make) in
            
            make.topMargin.equalTo(self.view.safeAreaInsets.top).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        // MARK: - Feed Body
        wfView.snp.makeConstraints{(make) in

            make.topMargin.equalTo(self.titleViewFeed.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
