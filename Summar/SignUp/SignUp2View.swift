//
//  SignUp2View.swift
//  Summar
//
//  Created by mac on 2022/10/25.
//

import Foundation
import SnapKit
import Alamofire

class SignUp2View : UIView{
    let pickerData = ["인문계열" , "사회계열" , "교육계열" , "공학계열" , "자연계열" , "의약계열" , "예체능계열"]  // 피커뷰에 보여줄 테스트 데이터
    var selectMajor = ""
    
    let serverURL = { () -> String in
        let url = Bundle.main.url(forResource: "Network", withExtension: "plist")
        let dictionary = NSDictionary(contentsOf: url!)

        // 각 데이터 형에 맞도록 캐스팅 해줍니다.
        #if DEBUG
        var LocalURL = dictionary!["DebugURL"] as? String
        #elseif RELEASE
        var LocalURL = dictionary!["ReleaseURL"] as? String
        #endif
        
        return LocalURL!
    }
    
    let helper = Helper()
    
    let btnWidth : CGFloat = {
        var btnWidth = UIScreen.main.bounds.width
        return btnWidth / 3 - 20
    }()
    
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "전공 또는\n학위를 입력해주세요"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.summarColor1
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.sizeToFit()
        return titleLabel
    }()
    
    let majorPickerView : UIPickerView = {
        let majorPickerView = UIPickerView()
        return majorPickerView
    }()
    
    let majorTextField : UITextField = {
        let majorTextField = UITextField()
        majorTextField.translatesAutoresizingMaskIntoConstraints = false
        majorTextField.layer.borderWidth = 1
        majorTextField.layer.borderColor = UIColor.white.cgColor
        majorTextField.backgroundColor = UIColor.textFieldColor
        majorTextField.layer.cornerRadius = 4
        majorTextField.placeholder = "전공 학과입력"
        majorTextField.addLeftPadding()
        majorTextField.font = .systemFont(ofSize: 15)
        majorTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        majorTextField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        majorTextField.addTarget(self, action: #selector(editingDidEnd(_:)), for: .editingDidEnd)
        majorTextField.textColor = .black
        return majorTextField
    }()
    
    let editMajor : UITextField = {
        let editMajor = UITextField()
        editMajor.translatesAutoresizingMaskIntoConstraints = false
        editMajor.layer.borderWidth = 1
        editMajor.layer.borderColor = UIColor.white.cgColor
        editMajor.backgroundColor = UIColor.textFieldColor
        editMajor.layer.cornerRadius = 4
//        editMajor.text = "전공 계열선택"
        editMajor.placeholder = "전공 계열선택"
        editMajor.addLeftPadding()
        editMajor.font = .systemFont(ofSize: 15)
        editMajor.textColor = .black
        return editMajor
    }()
    
//    let editMajor : UILabel = {
//        let editMajor = UILabel()
//        editMajor.translatesAutoresizingMaskIntoConstraints = false
//        editMajor.layer.borderWidth = 1
//        editMajor.layer.borderColor = UIColor.white.cgColor
//        editMajor.backgroundColor = UIColor.textFieldColor
//        editMajor.layer.cornerRadius = 4
//        editMajor.text = "전공 계열선택"
//        editMajor.font = .systemFont(ofSize: 15)
//        editMajor.textColor = .black
//        return editMajor
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(editMajor)
        addSubview(majorTextField)
        
        pickerViewInit()
        
        helper.lineSpacing(titleLabel, 10) // lineSpacing
        
        titleLabel.snp.makeConstraints{(make) in
            make.topMargin.equalTo(56)
            make.leftMargin.equalTo(25)
//            make.height.equalTo(24)
        }
        
        editMajor.snp.makeConstraints{(make) in
            make.topMargin.equalTo(titleLabel.snp.bottom).offset(40)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-125)
            make.height.equalTo(60)
        }
        
        majorTextField.snp.makeConstraints{(make) in
            make.topMargin.equalTo(editMajor.snp.bottom).offset(20)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-125)
//            make.rightMargin.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-25)
            make.height.equalTo(60)
        }
        
    }
    
    func pickerViewInit() {
        majorPickerView.delegate = self
        majorPickerView.dataSource = self
        // 피커뷰 툴바추가
        let pickerToolbar : UIToolbar = UIToolbar()
        pickerToolbar.barStyle = .default
        pickerToolbar.isTranslucent = true  // 툴바가 반투명인지 여부 (true-반투명, false-투명)
        pickerToolbar.backgroundColor = .lightGray
        pickerToolbar.sizeToFit()   // 서브뷰만큼 툴바 크기를 맞춤
        // 피커뷰 툴바에 확인/취소 버튼추가
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(onPickDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnCancel = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(onPickCancel))
        pickerToolbar.setItems([btnCancel , space , btnDone], animated: true)   // 버튼추가
        pickerToolbar.isUserInteractionEnabled = true   // 사용자 클릭 이벤트 전달
        
        editMajor.inputView = majorPickerView // 피커뷰 추가
        editMajor.inputAccessoryView = pickerToolbar // 피커뷰 툴바 추가
    }
    
    // 피커뷰 > 확인 클릭
    @objc func onPickDone() {
        editMajor.text = selectMajor
        editMajor.resignFirstResponder()
        selectMajor = ""
    }
    
    // 피커뷰 > 취소 클릭
    @objc func onPickCancel() {
        editMajor.resignFirstResponder() // 피커뷰를 내림 (텍스트필드가 responder 상태를 읽음)
        selectMajor = ""
    }
    
    @objc func textFieldDidChange(_ sender: Any){
        print(#function)
    }
    
    @objc func editingDidBegin(_ sender: Any){
        majorTextField.layer.borderWidth = 1
        majorTextField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @objc func editingDidEnd(_ sender: Any){
        majorTextField.layer.borderWidth = 1
        majorTextField.layer.borderColor = UIColor.white.cgColor
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SignUp2View : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // 피커뷰에 보여줄 값 전달
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // 피커뷰에서 선택시 호출
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectMajor = pickerData[row]
    }
}
