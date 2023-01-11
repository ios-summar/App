//
//  UpdateMyInfoViewController.swift
//  Summar
//
//  Created by mac on 2023/01/10.
//

import Foundation
import UIKit


class UpdateMyInfoViewController: UIViewController {
    static let shared = UpdateMyInfoViewController()
    // MARK: - Properties
    var userInfo: UserInfo? {
        didSet {
        }
    }
    
    let lbNavTitle : UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        title.text = "회원정보수정"
        title.font = .boldSystemFont(ofSize: 20)
        title.textColor = UIColor.summarColor1
        title.sizeToFit()
        return title
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 상단 타이틀, 버튼
        self.navigationItem.titleView = lbNavTitle
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(popScreen), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func popScreen(){
        self.navigationController?.popViewController(animated: true)
    }
}
