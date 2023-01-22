//
//  FeedDetailViewController.swift
//  Summar
//
//  Created by ukBook on 2023/01/22.
//

import Foundation
import UIKit

class FeedDetailViewController: UIViewController {
    static let shared = FeedDetailViewController()
    let feedView = FeedDetailVeiw()
    let helper = Helper()
    
    var feedInfo : FeedInfo? {
        didSet {
            print("\n \(feedInfo)")
        }
    }
    let titleLabel : UILabel = {
        let title = UILabel()
        title.text = "피드 상세보기"
        title.font = FontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    override func viewDidLoad() {
        configureUI()
    }
    
    /// UI 초기설정
    func configureUI() {
        // MARK: - SafeArea or View BackGroundColor Set
        
        // MARK: - NavigationBar
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(popView), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        // MARK: - addView
        self.view.addSubview(feedView)
        feedView.snp.makeConstraints{
            $0.right.left.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}
