//
//  SignUp1View.swift
//  Summar
//
//  Created by ukBook on 2022/10/23.
//

import Foundation
import UIKit
import SnapKit

class SignUp1View : UIView {

    let viewWidth : CGFloat = {
        // 뷰 전체 폭 길이
        var screenWidth = UIScreen.main.bounds.size.width
        var divScreen = screenWidth / 3 - 30
        return divScreen
    }()
    
    let viewLine1 : UIView = {
        let viewLine1 = UIView()
        viewLine1.translatesAutoresizingMaskIntoConstraints = false
        viewLine1.backgroundColor = UIColor.summarColor2
        return viewLine1
    }()
    
    let viewLine2 : UIView = {
        let viewLine2 = UIView()
        viewLine2.translatesAutoresizingMaskIntoConstraints = false
        viewLine2.backgroundColor = UIColor.grayColor
        return viewLine2
    }()
    
    let viewLine3 : UIView = {
        let viewLine3 = UIView()
        viewLine3.translatesAutoresizingMaskIntoConstraints = false
        viewLine3.backgroundColor = UIColor.grayColor
        return viewLine3
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print(viewWidth)
        
        addSubview(viewLine1)
        addSubview(viewLine2)
        addSubview(viewLine3)
        
        viewLine2.snp.makeConstraints {(make) in
            make.topMargin.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(viewWidth)
            make.height.equalTo(2)
        }
        
        viewLine1.snp.makeConstraints {(make) in
            make.centerY.equalTo(viewLine2.snp.centerY)
            make.rightMargin.equalTo(viewLine2.snp.left).offset(-20)
            make.width.equalTo(viewWidth)
            make.height.equalTo(2)
        }
        
        viewLine3.snp.makeConstraints {(make) in
            make.centerY.equalTo(viewLine2.snp.centerY)
            make.leftMargin.equalTo(viewLine2.snp.right).offset(20)
            make.width.equalTo(viewWidth)
            make.height.equalTo(2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
