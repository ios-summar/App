//
//  TabbarSearch.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit

final class SearchViewController : UIViewController, PushDelegateWithSearchUserInfo{
    func pushDeleagteWithParam(_ VC: UIViewController, _ searchUserInfo: SearchUserInfo) {
        if VC == ProfileViewController.shared {
            ProfileViewController.shared.searchUserInfo = searchUserInfo
            self.navigationController?.pushViewController(ProfileViewController.shared, animated: true)
        }
    }
    
    func pushScreen(_ VC: UIViewController) {
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    static let shared = SearchViewController()
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
        textField.frame = CGRect(x: 0, y: 0, width: viewWidth - 130, height: 80)
//        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.clear
        textField.textColor = .black
        textField.placeholder = "닉네임으로 검색"
//        textField.addLeftPadding()
        textField.addTarget(self, action: #selector(search), for: .editingChanged)
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
        configureDelegate()
        self.view.addSubview(searchView)
        self.view.backgroundColor = UIColor.searchGray
        
        self.navigationItem.titleView = textField
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view1)
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(deleteAction), uiImage: UIImage(systemName: "xmark")!, tintColor: UIColor.fontGrayColor)
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        // 네비게이션바 backgroundcolor
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white

//        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        if #available(iOS 16.0, *) {
//            self.navigationItem.rightBarButtonItem?.isHidden = true
        } else {
            // Fallback on earlier versions
        }
        
        view1.addSubview(magnifyingGlassBtn)
        
        magnifyingGlassBtn.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        searchView.snp.makeConstraints{(make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        search()
    }
    
    func configureDelegate() {
        searchView.pushDelegateWithSearchUserInfo = self
    }
    
    @objc func search() {
        guard let text = textField.text else { return }
        searchView.search(text)
    }
    
    @objc func deleteAction(){
        textField.text = ""
        searchView.search("")
    }
}

