//
//  PushSettingView.swift
//  Summar
//
//  Created by ukBook on 2023/01/14.
//

import Foundation
import UIKit

class PushSettingView: UIView {
    let viewModel = PushSettingViewModel()
    // MARK: - DB의 PushYN 초기값 설정
    var pushYN : Bool? {
        didSet {
            guard let pushYN = pushYN else {return}
            uiSwitch.isOn = pushYN
        }
    }
    
    let view : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let label : UILabel = {
        let label = UILabel()
        label.text = "푸시알림"
        label.textColor = .black
        label.font = FontManager.getFont(Font.Bold.rawValue).medium15Font
        label.sizeToFit()
        return label
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = FontManager.getFont(Font.Bold.rawValue).laergeFont
        label.text = "일반 알림"
        label.sizeToFit()
        return label
    }()
    
    let conentLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 115, g: 120, b: 127)
        label.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
        label.text = "좋아요, 댓글, 팔로우 등 알림"
        label.sizeToFit()
        return label
    }()
    
    var uiSwitch : UISwitch = {
        let UISwitch = UISwitch()
        UISwitch.onTintColor = .summarColor2
        UISwitch.addTarget(self, action: #selector(onClickSwitch(_:)), for: .valueChanged)
        return UISwitch
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.searchGray
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(15)
        }
        
        addSubview(view)
        view.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(label.snp.bottom).offset(15)
            $0.height.equalTo(100)
        }
        
        view.addSubview(uiSwitch)
        uiSwitch.snp.makeConstraints{
            $0.right.equalTo(-20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.bottom.equalTo(uiSwitch.snp.centerY).offset(-2)
            $0.left.equalTo(20)
        }
        
        view.addSubview(conentLabel)
        conentLabel.snp.makeConstraints{
            $0.top.equalTo(uiSwitch.snp.centerY).offset(2)
            $0.left.equalTo(20)
        }
    }
    
    func pushStatus(){
        viewModel.getPushYN()
        viewModel.didFinishFetch = {
            self.pushYN = self.viewModel.pushYn
        }
    }
    
    @objc func onClickSwitch(_ sender: Any) {
        let uiSwitch = sender as! UISwitch
        let pushYN = uiSwitch.isOn
        smLog("\(String(uiSwitch.isOn))")
        
        viewModel.changePushYN(pushYN)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

