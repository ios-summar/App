//
//  TabbarSearch.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit

class TabbarSearch : UIViewController{
    func pushScreen(_ VC: UIViewController) {
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    static let shared = TabbarSearch()
    let searchView = SearchView.shared
    
    let viewWidth : CGFloat = {
        var btnWidth = UIScreen.main.bounds.width
        return btnWidth
    }()
    
    let view1 : UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        return view
    }()
    
    lazy var textField : UITextField = {
        let textField = UITextField()
        textField.frame = CGRect(x: 0, y: 0, width: viewWidth - 115, height: 80)
//        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.clear
        textField.textColor = .black
        textField.placeholder = "닉네임으로 검색"
        textField.addLeftPadding()
//        textField.addTarget(self, action: #selector(search), for: .editingChanged)
        textField.attributedPlaceholder = NSAttributedString(string: "닉네임으로 검색", attributes: [NSAttributedString.Key.foregroundColor : UIColor.imageViewColor])
        return textField
    }()
    
    let magnifyingGlassBtn : UIButton = {
        let magnifyingGlass = UIButton()
        magnifyingGlass.setImage(UIImage(named: "Union"), for: .normal)
        magnifyingGlass.tintColor = .black
        magnifyingGlass.imageView?.contentMode = .scaleToFill
        magnifyingGlass.tag = 2
        return magnifyingGlass
    }()
    
    let magnifyingGlass : UIBarButtonItem = {
        let magnifyingGlass = UIBarButtonItem()
        magnifyingGlass.image = UIImage(named: "Union")
        magnifyingGlass.tag = 2
        return magnifyingGlass
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(searchView)
        
        self.navigationItem.titleView = textField
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view1)
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(deleteAction), uiImage: UIImage(systemName: "xmark")!, tintColor: UIColor(red: 158/255, green: 164/255, blue: 170/255, alpha: 1))
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        view1.addSubview(magnifyingGlassBtn)
        
        magnifyingGlassBtn.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        searchView.snp.makeConstraints{(make) in
            make.topMargin.equalTo(self.view.safeAreaInsets.top).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc func deleteAction(){
        textField.text = ""
    }
}

