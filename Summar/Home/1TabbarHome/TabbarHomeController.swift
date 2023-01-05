//
//  TabbarHomeController.swift
//  Summar
//
//  Created by ukBook on 2022/12/10.
//

import Foundation
import UIKit
import SnapKit

class TabbarHomeController : UIViewController {
    static let shared = TabbarHomeController()
    
    let titleView = TitleViewHome.shared
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
    
    let heartBtn : UIBarButtonItem = {
        let heartBtn = UIBarButtonItem()
        heartBtn.image = UIImage(systemName: "heart")
//        heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        heartBtn.tintColor = .black
//        heartBtn.imageView?.contentMode = .scaleToFill
//        heartBtn.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 33, right: 35)
//        heartBtn.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        heartBtn.tag = 1
        return heartBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.addSubview(titleView)
        self.view.addSubview(homeView)
//        titleView.backgroundColor = UIColor.BackgroundColor
//        titleView.layer.borderWidth = 1
        
        let lbNavTitle = UIView (frame: CGRect(x: 0, y: 0, width: viewWidth, height: 40))
        lbNavTitle.layer.borderWidth = 1
        
        _ = [titleImageView].map {
            lbNavTitle.addSubview($0)
        }
        
//        lbNavTitle.textColor = UIColor.black
//        lbNavTitle.numberOfLines = 0
//        lbNavTitle.center = CGPoint(x: 0, y: 0)
//        lbNavTitle.textAlignment = .left
    //        lbNavTitle.font = UIFont(name: "나눔손글씨 암스테르담", size: 24)
//        lbNavTitle.text = "기프티콘 저장"
//        self.navigationItem.titleView = lbNavTitle
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: lbNavTitle)
//        self.navigationItem.backBarButtonItem =
        self.navigationItem.rightBarButtonItem = heartBtn
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

