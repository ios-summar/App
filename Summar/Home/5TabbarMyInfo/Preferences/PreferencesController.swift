//
//  PreferencesController.swift
//  Summar
//
//  Created by mac on 2023/01/04.
//

import Foundation
import UIKit
import SnapKit

class PreferencesController: UIViewController{
    static let shared = PreferencesController()
    let preferencesView = PreferencesView()
    
    let titleLabel : UILabel = {
        let title = UILabel()
        title.text = "환경 설정"
        title.font = .boldSystemFont(ofSize: 20)
        title.textColor = UIColor.summarColor1
        title.sizeToFit()
        return title
    }()
    
    let arrowBackWard : UIButton = {
        let arrowBackWard = UIButton()
        arrowBackWard.setImage(UIImage(systemName: "arrow.backward"), for: .normal) // ios 14.0
        arrowBackWard.tintColor = .black
        arrowBackWard.imageView?.contentMode = .scaleToFill
//        xmark.imageEdgeInsets = UIEdgeInsets(top: 32, left: 33, bottom: 33, right: 33)
//        arrowBackWard.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        arrowBackWard.tag = 1
        return arrowBackWard
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(preferencesView)
        self.view.backgroundColor = .white
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(topBtnAction(_:)), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        
        
        preferencesView.snp.makeConstraints{(make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    
    
    @objc func topBtnAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
