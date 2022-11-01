//
//  SignUp2View.swift
//  Summar
//
//  Created by mac on 2022/10/25.
//

import Foundation
import SnapKit

enum Interests : String{
    case graphicDesign = "그래픽 디자인"
    case photoGrapher = "포토그래퍼"
    case videoCreator = "영상 크리에이터"
    case constructionDesign = "건축 설계"
    case foodStyling = "푸드 스타일링"
    case makeUp = "메이크업, 헤어"
    case crafts = "공예/DIY"
    case motionGraphic = "모션 그래픽"
    case threeDModeler = "3D 모델러"
    case branding = "브랜딩/편집"
    case fitness = "피트니스"
    case dance = "댄스/뮤직"
}

class SignUp2View : UIView{
    
    let helper = Helper()
    let btnWidth : CGFloat = {
        var btnWidth = UIScreen.main.bounds.width
        return btnWidth / 3 - 20
    }()
    
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "관심분야를 다섯건 이내로 선택해주세요"
        titleLabel.textColor = UIColor.summarColor1
        titleLabel.font = .boldSystemFont(ofSize: 20)
        return titleLabel
    }()
    
    let btn1 : UIButton = {
        let btn1 = UIButton()
        btn1.setTitle(Interests.graphicDesign.rawValue, for: .normal)
        btn1.backgroundColor = UIColor.grayColor245
        return btn1
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
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
