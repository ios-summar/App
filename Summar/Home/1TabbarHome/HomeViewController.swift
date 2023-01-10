//
//  TabbarHomeController.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController : UIViewController {
    static let shared = HomeViewController()
    let homeView = HomeView.shared
    
    let viewWidth : CGFloat = {
        var btnWidth = UIScreen.main.bounds.width
        return btnWidth
    }()
    
    let titleImageView : UIImageView = {
        let title = UIImageView()
        title.image = UIImage(named: "Title")
        return title
    }()
    
    let directBtn : UIButton = {
        let directBtn = UIButton()
        directBtn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        directBtn.tintColor = .black
        directBtn.imageView?.contentMode = .scaleToFill
        directBtn.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 33, right: 35)
//        directBtn.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        directBtn.tag = 2
        return directBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(homeView)
        
        let lbNavTitle = UIView (frame: CGRect(x: 0, y: 0, width: viewWidth, height: 40))
        lbNavTitle.layer.borderWidth = 1
        
        _ = [titleImageView].map {
            lbNavTitle.addSubview($0)
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: lbNavTitle)
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(topBtnAction(_:)), uiImage: UIImage(systemName: "heart")!, tintColor: .black)
        
        titleImageView.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.equalTo(72)
            make.height.equalTo(18)
        }
        
        homeView.snp.makeConstraints{(make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(0)
        }
        
    }
    
    @objc func topBtnAction(_ sender: Any){
        print(#file , #function)
    }
}

