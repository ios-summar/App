//
//  SignUp2View.swift
//  Summar
//
//  Created by mac on 2022/10/25.
//

import Foundation
import SnapKit

class SignUp2View : UIView {
    
    let helper = Helper()
    
    let testLabel : UILabel = {
        let testLabel = UILabel()
        testLabel.text = "test"
        return testLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(testLabel)

        testLabel.snp.makeConstraints{(make) in
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
