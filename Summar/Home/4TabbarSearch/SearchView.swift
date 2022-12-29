//
//  TitleViewSearch.swift
//  Summar
//
//  Created by ukBook on 2022/12/27.
//

import Foundation
import UIKit
import SnapKit


class SearchView: UIView{
    static let shared = SearchView()
    let viewModel = SearchViewModel.shared
    
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
        xMark.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        xMark.tintColor = .black
        xMark.imageView?.contentMode = .scaleToFill
        xMark.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 33, right: 35)
        xMark.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        xMark.layer.borderWidth = 1
        xMark.tag = 1
        xMark.alpha = 0.0
        return xMark
    }()
    
    let view : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        return view
    }()
    
    
    let searchImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill.questionmark")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    let label : UILabel = {
        let label = UILabel()
        label.text = "닉네임을 검색해 사용자를 찾아보세요"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemGray
        label.sizeToFit()
        return label
    }()
    
    lazy var searchTableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _ = [textField, view].map {
            addSubview($0)
        }
        
        _ = [searchImageView, label].map {
            view.addSubview($0)
        }
        
        textField.addSubview(xMark)
        
        textField.snp.makeConstraints{(make) in
            make.left.equalTo(20)
//            make.bottom.equalTo(-10)
            make.top.equalTo(10)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }
        
        xMark.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.snp.makeConstraints{(make) in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.left.bottom.right.equalToSuperview()
        }
        
        searchImageView.snp.makeConstraints{(make) in
            make.top.equalTo(50)
            make.width.equalTo(100)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints{(make) in
            make.top.equalTo(searchImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
    
    
    @objc func topBtnAction(_ sender: Any) {
        let tagValue = (sender as? UIButton)?.tag
        
        switch tagValue {
        case 1: // Delete Action
            print("Delete Action")
            isEmpty(true)
            textField.text = ""
        case 2: // DirectMessage Event
            print("DirectMessage")
        default:
            print("default")
        }
    }
    
    @objc func search(){
        if (textField.text?.isEmpty)! {
            isEmpty(true)
        }else {
            let nickname = textField.text!
            isEmpty(false)
            
            //Network Call
            viewModel.serachNickname(nickname)
        }
    }
    
    // MARK: - TextField Empty 유무로 UI SetUp
    func isEmpty(_ TF : Bool){
        if TF { // textField가 비어있지 않음
            xMark.alpha = 0.0
            
            _ = [searchImageView, label].map {
                view.addSubview($0)
            }
            
            searchImageView.snp.makeConstraints{(make) in
                make.top.equalTo(50)
                make.width.equalTo(100)
                make.height.equalTo(80)
                make.centerX.equalToSuperview()
            }
            
            label.snp.makeConstraints{(make) in
                make.top.equalTo(searchImageView.snp.bottom).offset(30)
                make.centerX.equalToSuperview()
            }
        }else{
            xMark.alpha = 1.0
            _ = [searchImageView, label].map {
                $0.removeFromSuperview()
            }
            
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
