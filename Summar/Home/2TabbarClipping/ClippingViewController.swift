//
//  TabbarClipping.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit

final class ClippingViewController : UIViewController, ViewAttributes, HomeViewDelegate{
    let fontManager = FontManager.shared
    
    func pushScreen(_ VC: UIViewController, _ any: Any) {
        if VC.isKind(of: FeedDetailViewController.self) {
            let VC = FeedDetailViewController()
            
            VC.feedInfo = any as? FeedInfo
            self.navigationController?.pushViewController(VC, animated: true)
        }else if VC.isKind(of: ProfileViewController.self) {
            let VC = ProfileViewController()
            
            VC.userSeq = any as? Int
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    let clippingView = ClippingView()
    lazy var lbNavTitle : UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        title.text = "스크랩보기"
        title.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clippingView.delegate = self
        
        setUI()
        setAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clippingView.selectFeed()
    }
    
    func setUI(){
        // MARK: - 마이 써머리 상단 타이틀, 버튼
        self.navigationItem.titleView = lbNavTitle
        self.view.addSubview(clippingView)
    }
    
    func setAttributes() {
        clippingView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

