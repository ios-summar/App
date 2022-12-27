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
    
    // Constraint 타입 선언
    private var textFieldRightConstraint: Constraint?
    
    let textField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.systemGray5
        textField.textColor = .white
        textField.placeholder = "닉네임으로 검색"
        textField.addLeftPadding()
        textField.addTarget(self, action: #selector(searchStart), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(searchEnd), for: .editingDidEnd)
        return textField
    }()
    
    let directBtn : UIButton = {
        let directBtn = UIButton()
        directBtn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        directBtn.tintColor = .black
        directBtn.imageView?.contentMode = .scaleToFill
        directBtn.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 33, right: 35)
        directBtn.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        directBtn.tag = 2
        return directBtn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textField)
//        addSubview(directBtn)
        
//        directBtn.snp.makeConstraints{(make) in
//            make.centerY.equalToSuperview()
//            make.rightMargin.equalTo(-20)
//            make.width.equalTo(40)
//            make.height.equalTo(40)
//        }
        
        textField.snp.makeConstraints{(make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-10)
            make.top.equalTo(10)
//            make.right.equalTo(-20)
            self.textFieldRightConstraint = make.right.equalTo(-20).constraint
        }
    }
    
    @objc func topBtnAction(_ sender: Any) {
        let tagValue = (sender as? UIButton)?.tag
        
        switch tagValue {
        case 1: // Heart Event
            print("heart")
        case 2: // DirectMessage Event
            print("DirectMessage")
        default:
            print("default")
        }
    }
    
    @objc func searchStart(){
        self.textFieldRightConstraint?.update(offset: -50)
    }
    
    @objc func searchEnd(){
        print(#file , #function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
