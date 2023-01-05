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
    
    let titleLabel : UILabel = {
        let title = UILabel()
        title.text = "이미지 크게보기"
        title.font = .boldSystemFont(ofSize: 20)
        title.textColor = UIColor.summarColor1
        title.sizeToFit()
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(topBtnAction(_:)), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        
        
        _ = [fullScreenImageView].map {
            self.view.addSubview($0)
//            $0.layer.borderWidth = 1
        }
        
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
