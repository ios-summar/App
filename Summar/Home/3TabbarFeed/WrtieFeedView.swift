//
//  WrtieFeedView.swift
//  Summar
//
//  Created by mac on 2022/12/22.
//

import Foundation
import UIKit

protocol WriteFeedDelegate : class {
    func closAction()
}

class WriteFeedView : UIView {
    static let shared = WriteFeedView()
    weak var delegate : WriteFeedDelegate?
    
    let xMark : UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.tintColor = .black
        view.layer.borderWidth = 1
        view.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(xMark)
        
        
        xMark.snp.makeConstraints{(make) in
            
            make.width.height.equalTo(40)
//            make.top.left.equalTo(20)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-20)
        }
    }
    
    @objc func closeAction(){
//        self.dismiss(animated: true, completion: nil)
        self.delegate?.closAction()
        print(#file , #function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
