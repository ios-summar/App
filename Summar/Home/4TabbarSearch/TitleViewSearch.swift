//
//  TitleViewSearch.swift
//  Summar
//
//  Created by ukBook on 2022/12/27.
//

import Foundation
import UIKit
import SnapKit


class TitleViewSearch: UIView{
    static let shared = TitleViewSearch()
    
    let textField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.systemGray5
        textField.textColor = .black
        textField.placeholder = "닉네임으로 검색"
        textField.addLeftPadding()
        textField.addTarget(self, action: #selector(search), for: .editingChanged)
        return textField
    }()
    
    let xMark : UIButton = {
        let xMark = UIButton()
        xMark.setImage(UIImage(systemName: "xmark"), for: .normal)
        xMark.tintColor = .black
        xMark.imageView?.contentMode = .scaleToFill
        xMark.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 33, right: 35)
        xMark.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        xMark.layer.borderWidth = 1
        xMark.tag = 1
        xMark.alpha = 0.0
        return xMark
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textField)
        textField.addSubview(xMark)
        
        textField.snp.makeConstraints{(make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-10)
            make.top.equalTo(10)
            make.right.equalTo(-20)
        }
        
        xMark.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    @objc func topBtnAction(_ sender: Any) {
        let tagValue = (sender as? UIButton)?.tag
        
        switch tagValue {
        case 1: // Delete Action
            print("Delete Action")
            textField.text = ""
        case 2: // DirectMessage Event
            print("DirectMessage")
        default:
            print("default")
        }
    }
    
    @objc func search(){
        print(#file , #function)
        
        if (textField.text?.isEmpty)! {
            xMark.alpha = 0.0
        }else {
            xMark.alpha = 1.0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
