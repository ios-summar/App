//
//  SignUp2View.swift
//  Summar
//
//  Created by mac on 2022/10/25.
//

import Foundation
import SnapKit


class SignUp2View : UIView{
    
    let helper = Helper()
    
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "관심분야를 다섯건 이내로 선택해주세요"
        titleLabel.textColor = UIColor.summarColor1
        titleLabel.font = .boldSystemFont(ofSize: 20)
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints{(make) in
            make.topMargin.equalTo(56)
            make.leftMargin.equalTo(25)
            make.height.equalTo(24)
        }
        
    }
    

    @objc func textFieldDidChange(_ sender: Any) {
        if let textField = sender as? UITextField {
            if (textField.text?.count ?? 0 > 11) {
                textField.deleteBackward()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
