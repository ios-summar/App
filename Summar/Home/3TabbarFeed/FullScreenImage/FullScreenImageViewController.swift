//
//  FullScreenImageController.swift
//  Summar
//
//  Created by ukBook on 2022/12/31.
//

import Foundation
import UIKit


final class FullScreenImageViewController: UIViewController, ViewAttributes {
    let fullScreenImageView = FullScreenImageView()
    let fontManager = FontManager.shared
    
    // MARK: - Properties
    var imageArr: [UIImage]? {
        didSet {
            guard let array = imageArr else { return }
            print("array \(array)")
            fullScreenImageView.initImageArr(imageArr: array)
        }
    }
    lazy var titleLabel : UILabel = {
        
        let title = UILabel()
        title.text = "이미지 크게보기"
        title.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = .black
        title.sizeToFit()
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAttributes()
    }
    
    func setUI() {
        
        // MARK: - SafeArea or View BackGroundColor Set
        fillSafeArea(position: .top, color: .white)
        fillSafeArea(position: .left, color: .white)
        fillSafeArea(position: .right, color: .white)
        fillSafeArea(position: .bottom, color: .white)
        
        // MARK: - addView
        self.view.addSubview(fullScreenImageView)
        
        // MARK: - NavigationBar
        self.view.backgroundColor = .white
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(leftBtnAction(_:)), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        self.navigationItem.rightBarButtonItem = makeSFSymbolButtonLabel(self, action: #selector(rightBtnAction(_:)), title: "변경 후 저장", tintColor: UIColor.magnifyingGlassColor)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setAttributes() {
        
        fullScreenImageView.snp.makeConstraints{(make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    
    @objc func leftBtnAction(_ sender: Any){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBtnAction(_ sender: Any){
        
        smLog("")
    }
    
    func makeSFSymbolButtonLabel(_ target: Any?, action: Selector, title: String, tintColor : UIColor) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = tintColor
            
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
        return barButtonItem
    }
}
