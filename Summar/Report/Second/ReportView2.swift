//
//  ReportView2.swift
//  Summar
//
//  Created by plsystems on 2023/02/09.
//

import Foundation
import UIKit

final class ReportView2: UIView, ViewAttributes, UITextViewDelegate, UITextFieldDelegate {
    let fontManager = FontManager.shared
    weak var delegate: UpdateNavigationBar?
    
    var reportReason: String? {
        didSet {
            report1TextField.text = reportReason
        }
    }
    var param: Dictionary<String, Any>? {
        didSet {
            smLog("\(param)")
        }
    }
    
    let textViewPlaceHolder = "상세한 신고 내용을 작성해 주세요."
    var sendBool: Bool = false
    
    let view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var report1Label: UILabel = {
        let label = UILabel()
        label.text = "신고 이유"
        label.textColor = .black
        label.font = self.fontManager.getFont(Font.Bold.rawValue).medium15Font
        label.sizeToFit()
        return label
    }()
    
    lazy var report1TextField: UITextField = {
        let textField = PaddingTextField()
        textField.font = self.fontManager.getFont(Font.Regular.rawValue).mediumFont
        textField.textColor = .black
        
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = UIColor.Gray02.cgColor
        textField.backgroundColor = UIColor.Gray01
        
        textField.isEnabled = false
        return textField
    }()
    
    lazy var report2Label: UILabel = {
        let label = UILabel()
        label.text = "신고 내용"
        label.textColor = .black
        label.font = self.fontManager.getFont(Font.Bold.rawValue).medium15Font
        label.sizeToFit()
        return label
    }()
    
    let view2: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.Gray02.cgColor
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 4
        return view
    }()
    
    lazy var view2TextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.white
        textView.font = self.fontManager.getFont(Font.Regular.rawValue).medium15Font
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        textView.delegate = self
        textView.tag = 3
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.Gray02
        
        setUI()
        setAttributes()
    }
    
    
    func setUI() {
        addSubview(view)
        view.addSubview(report1Label)
        view.addSubview(report1TextField)
        
        view.addSubview(report2Label)
        view.addSubview(view2)
        view2.addSubview(view2TextView)
    }
    
    func setAttributes() {
        view.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(1)
            $0.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        report1Label.snp.makeConstraints {
            $0.left.top.equalTo(20)
        }
        
        report1TextField.snp.makeConstraints {
            $0.top.equalTo(report1Label.snp.bottom).offset(7)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(45)
        }
        
        // 신고내용
        report2Label.snp.makeConstraints{(make) in
            make.left.equalTo(20)
            make.top.equalTo(report1TextField.snp.bottom).offset(26)
        }
        
        view2.snp.makeConstraints{(make) in
            make.top.equalTo(report2Label.snp.bottom).offset(7)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(176)
        }
        
        view2TextView.snp.makeConstraints{(make) in
            make.top.equalTo(11.5)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-11.5)
        }
    }
    
    // MARK: - PlaceHolder 작업
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 999 {
            textView.deleteBackward()
        }
        
        if textView.text.count != 0{
            sendBool = true
        }else {
            sendBool = false
        }
        
        self.delegate?.updateNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

