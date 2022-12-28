//
//  TitleWriteFeed.swift
//  Summar
//
//  Created by mac on 2022/12/28.
//

import Foundation
import UIKit

protocol WriteFeedDelegate : class {
    func closAction()
}

class TitleWriteFeed: UIView {
    static let shared = TitleWriteFeed()
    weak var delegate : WriteFeedDelegate?
    
    let title : UILabel = {
        let title = UILabel()
        title.text = "피드 작성"
        title.font = .boldSystemFont(ofSize: 20)
        title.textColor = UIColor.summarColor1
        title.sizeToFit()
        return title
    }()
    
    let xMark : UIButton = {
        let xmark = UIButton()
        xmark.setImage(UIImage(systemName: "xmark"), for: .normal) // ios 14.0
        xmark.tintColor = .black
        xmark.imageView?.contentMode = .scaleToFill
        xmark.imageEdgeInsets = UIEdgeInsets(top: 32, left: 33, bottom: 33, right: 33)
        xmark.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        xmark.tag = 1
        return xmark
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        addSubview(xMark)
        
        backgroundColor = UIColor.white
        
        title.snp.makeConstraints{(make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        xMark.snp.makeConstraints{(make) in
            make.centerY.equalTo(title.snp.centerY)
            make.rightMargin.equalTo(-20)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    @objc func topBtnAction(_ sender: Any) {
        let tagValue = (sender as? UIButton)?.tag
        
        switch tagValue {
        case 1: // 닫기
            print("닫기")
            self.delegate?.closAction()
        default:
            print("default")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
