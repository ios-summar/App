//
//  FullScreenImageController.swift
//  Summar
//
//  Created by ukBook on 2022/12/31.
//

import Foundation
import UIKit


final class FullScreenImageViewController: UIViewController {
    static let shared = FullScreenImageViewController()
    
    let fullScreenImageView = FullScreenImageView.shared
    
    // MARK: - Properties
    var imageArr: [UIImage]? {
        didSet {
            guard let array = imageArr else { return }
            print("array \(array)")
            fullScreenImageView.initImageArr(imageArr: array)
        }
    }
    
    let titleLabel : UILabel = {
        let title = UILabel()
        title.text = "이미지 크게보기"
        title.font = FontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = .black
        title.sizeToFit()
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    /// UI 초기설정
    func configureUI() {
        // MARK: - SafeArea or View BackGroundColor Set
        fillSafeArea(position: .top, color: .white)
        fillSafeArea(position: .left, color: .white)
        fillSafeArea(position: .right, color: .white)
        fillSafeArea(position: .bottom, color: .white)
        
        // MARK: - NavigationBar
        self.view.backgroundColor = .white
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(topBtnAction(_:)), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        
        // MARK: - addView
        self.view.addSubview(fullScreenImageView)
        fullScreenImageView.snp.makeConstraints{(make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func topBtnAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
