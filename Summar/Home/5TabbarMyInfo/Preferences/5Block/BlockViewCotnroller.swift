//
//  BlockViewCotnroller.swift
//  Summar
//
//  Created by plsystems on 2023/03/23.
//

import Foundation
import UIKit

final class BlockViewCotnroller: UIViewController, ViewAttributes {
    let fontManager = FontManager.shared
    
    lazy var titleLabel : UILabel = {
        let title = UILabel()
        title.text = "차단 목록"
        title.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setAttributes()
    }
    
    func setNavigationBar() {
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(topBtnAction(_:)), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
    }
    
    func setUI() {
        
        self.view.backgroundColor = .white
    }
    
    func setAttributes() {
        
    }
    
    @objc func topBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
