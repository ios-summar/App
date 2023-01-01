//
//  FullScreenImageController.swift
//  Summar
//
//  Created by ukBook on 2022/12/31.
//

import Foundation
import UIKit


class FullScreenImageController: UIViewController {
    static let shared = FullScreenImageController()
    
    let fullScreenImageView = FullScreenImageView.shared
    
    // MARK: - Properties
    var imageArr: [UIImage]? {
        didSet {
            guard let array = imageArr else { return }
            print("array \(array)")
            fullScreenImageView.initImageArr(imageArr: array)
        }
    }
    
    let titleView = UIView()
    
    let titleLabel : UILabel = {
        let title = UILabel()
        title.text = "이미지 크게보기"
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
        arrowBackWard.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        arrowBackWard.tag = 1
        return arrowBackWard
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.borderWidth = 1
        
        
        _ = [titleView, fullScreenImageView].map {
            self.view.addSubview($0)
//            $0.layer.borderWidth = 1
        }
        
        _ = [titleLabel, arrowBackWard].map {
            titleView.addSubview($0)
//            $0.layer.borderWidth = 1
        }
        
        titleView.snp.makeConstraints{(make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
        
        arrowBackWard.snp.makeConstraints{(make) in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.left.equalTo(20)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        fullScreenImageView.snp.makeConstraints{(make) in
            make.left.right.equalTo(0)
            make.top.equalTo(titleView.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func topBtnAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
