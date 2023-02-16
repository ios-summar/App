//
//  SignUp2View.swift
//  Summar
//
//  Created by mac on 2022/10/25.
//

import Foundation
import SnapKit
import Alamofire

protocol SignUp2Delegate : AnyObject {
    func majorInput(major1: String, major2: String)
}

final class SignUp2View : UIView{
    let pickerData = ["" ,"인문계열" , "사회계열" , "교육계열" , "공학계열" , "자연계열" , "의약계열" , "예체능계열"]  // 피커뷰에 보여줄 테스트 데이터
    let majorName1 = ["" ,"언어ㆍ문학", "인문과학"] //인문계열
    let majorName2 = ["" ,"경영ㆍ경제", "사회과학", "법률"] //사회계열
    let majorName3 = ["" ,"유아교육", "교육일반", "특수교육"] //교육계열
    let majorName4 = ["" ,"건축", "토목ㆍ도시", "교통ㆍ운송", "기계ㆍ금속", "전기ㆍ전자", "소재ㆍ재료", "컴퓨터ㆍ통신", "화공", "정밀ㆍ에너지", "산업", "기타"] //공학계열
    let majorName5 = ["" ,"농림ㆍ수산", "수학ㆍ물리ㆍ천문ㆍ지리", "생물ㆍ화학ㆍ환경", "생활과학"] //자연계열
    let majorName6 = ["" ,"치료ㆍ보건", "의료"] //의약계열
    let majorName7 = ["" ,"디자인", "응용예술", "무용ㆍ체육", "연극ㆍ영화", "음악", "미술ㆍ조형"] //예체능계열
    
    
    var selectMajor1 = ""
    var selectMajor2 = ""
    
    var majorDetailIndex : Int = 0
    
    weak var delegate : SignUp2Delegate?
    
    let helper = Helper.shared
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
        majorPickerView.tag = 0
        return majorPickerView
    }()
    
    let majorDetailPickerView : UIPickerView = {
        let majorDetailPickerView = UIPickerView()
        majorDetailPickerView.tag = 1
        return majorDetailPickerView
    }()
    
    let editMajor : UITextField = {
        let editMajor = UITextField()
        editMajor.tintColor = .textFieldColor
        editMajor.translatesAutoresizingMaskIntoConstraints = false
        editMajor.layer.borderWidth = 1
        editMajor.layer.borderColor = UIColor.white.cgColor
        editMajor.backgroundColor = UIColor.textFieldColor
        editMajor.layer.cornerRadius = 4
        editMajor.placeholder = "전공 계열선택"
        editMajor.attributedPlaceholder = NSAttributedString(string: "전공 계열선택", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor205])
        editMajor.addLeftPadding()
        editMajor.font = .systemFont(ofSize: 15)
        editMajor.textColor = .black
        editMajor.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        editMajor.addTarget(self, action: #selector(editingDidEnd(_:)), for: .editingDidEnd)
        editMajor.tag = 0
        return editMajor
    }()
    
    let majorTextField : UITextField = {
        let majorTextField = UITextField()
        majorTextField.tintColor = .textFieldColor
        majorTextField.translatesAutoresizingMaskIntoConstraints = false
        majorTextField.layer.borderWidth = 1
        majorTextField.layer.borderColor = UIColor.white.cgColor
        majorTextField.backgroundColor = UIColor.textFieldColor
        majorTextField.layer.cornerRadius = 4
        majorTextField.placeholder = "전공 학과선택"
        majorTextField.attributedPlaceholder = NSAttributedString(string: "전공 학과선택", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor205])
        majorTextField.addLeftPadding()
        majorTextField.textColor = .black
        majorTextField.font = .systemFont(ofSize: 15)
        majorTextField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        majorTextField.addTarget(self, action: #selector(editingDidEnd(_:)), for: .editingDidEnd)
        majorTextField.tag = 1
        return majorTextField
    }()
    
    let sendBtn : UIButton = {
        let sendBtn = UIButton()
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.setTitle("다음", for: .normal)
        sendBtn.setTitleColor(.white, for: .normal)
        sendBtn.titleLabel?.font = .systemFont(ofSize: 15)
        sendBtn.backgroundColor = UIColor.grayColor205
        sendBtn.layer.cornerRadius = 4
        sendBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return sendBtn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(editMajor)
        addSubview(majorTextField)
        addSubview(sendBtn)
        
        pickerViewInit()
        
        helper.lineSpacing(titleLabel, 10) // lineSpacing
        
        titleLabel.snp.makeConstraints{(make) in
            make.topMargin.equalTo(30)
            make.leftMargin.equalTo(25)
//            make.height.equalTo(24)
        }
        
        editMajor.snp.makeConstraints{(make) in
            make.topMargin.equalTo(titleLabel.snp.bottom).offset(40)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(60)
        }
        
        majorTextField.snp.makeConstraints{(make) in
            make.topMargin.equalTo(editMajor.snp.bottom).offset(20)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(60)
        }
        
        sendBtn.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(-25)
            make.leftMargin.equalTo(25)
            make.rightMargin.equalTo(-25)
            make.height.equalTo(52)
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
        
        
        // 피커뷰 툴바추가
        let pickerToolbar1 : UIToolbar = UIToolbar()
        pickerToolbar1.barStyle = .default
        pickerToolbar1.isTranslucent = true  // 툴바가 반투명인지 여부 (true-반투명, false-투명)
        pickerToolbar1.backgroundColor = .lightGray
        pickerToolbar1.sizeToFit()   // 서브뷰만큼 툴바 크기를 맞춤
        // 피커뷰 툴바에 확인/취소 버튼추가
        let btnDone1 = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(onPickDone1))
        let space1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnCancel1 = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(onPickCancel1))
        pickerToolbar1.setItems([btnCancel1 , space1 , btnDone1], animated: true)   // 버튼추가
        pickerToolbar1.isUserInteractionEnabled = true   // 사용자 클릭 이벤트 전달
        
        majorTextField.inputView = majorDetailPickerView // 피커뷰 추가
        majorTextField.inputAccessoryView = pickerToolbar1 // 피커뷰 툴바 추가
//
    }
    
    // 피커뷰 > 확인 클릭
    @objc func onPickDone() {
        editMajor.text = selectMajor1
        editMajor.resignFirstResponder()
        majorTextField.text = ""
        
        if editMajor.text?.isEmpty ?? true || majorTextField.text?.isEmpty ?? true{
            self.sendBtnEnable(false)
        }else {
            self.sendBtnEnable(true)
        }
    }
    
    // 피커뷰 > 취소 클릭
    @objc func onPickCancel() {
        editMajor.resignFirstResponder() // 피커뷰를 내림 (텍스트필드가 responder 상태를 읽음)
//        selectMajor1 = ""
    }
    
    @objc func onPickDone1() {
        majorTextField.text = selectMajor2
        majorTextField.resignFirstResponder()
//        selectMajor2 = ""
        
        if editMajor.text?.isEmpty ?? true || majorTextField.text?.isEmpty ?? true{
            self.sendBtnEnable(false)
        }else {
            self.sendBtnEnable(true)
        }
    }
    
    // 피커뷰 > 취소 클릭
    @objc func onPickCancel1() {
        majorTextField.resignFirstResponder() // 피커뷰를 내림 (텍스트필드가 responder 상태를 읽음)
//        selectMajor2 = ""
    }
    
    
    func sendBtnEnable(_ TF: Bool) {
        if TF {
            sendBtn.isEnabled = true
            sendBtn.backgroundColor = UIColor.summarColor2
        }else {
            sendBtn.isEnabled = false
            sendBtn.backgroundColor = UIColor.grayColor205
        }
    }
    
    @objc func editingDidBegin(_ sender: Any){
        switch (sender as? UITextField)?.tag {
            case 0:
                editMajor.layer.borderWidth = 1
                editMajor.layer.borderColor = UIColor.systemBlue.cgColor
            case 1:
                majorTextField.layer.borderWidth = 1
                majorTextField.layer.borderColor = UIColor.systemBlue.cgColor
            default:
                print("default")
        }
    }
    
    @objc func editingDidEnd(_ sender: Any){
        switch (sender as? UITextField)?.tag {
            case 0:
                editMajor.layer.borderWidth = 1
                editMajor.layer.borderColor = UIColor.white.cgColor
            case 1:
                majorTextField.layer.borderWidth = 1
                majorTextField.layer.borderColor = UIColor.white.cgColor
            default:
                print("default")
        }
    }
    
    @objc func nextAction(){
        self.delegate?.majorInput(major1: editMajor.text!, major2: majorTextField.text!)
        
        editMajor.text = ""
        majorTextField.text = ""
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
        switch pickerView.tag {
            case 0:
                return pickerData.count
            case 1:
                return majorDetailIndex
            default:
                return 0
        }
    }
    
    // 피커뷰에 보여줄 값 전달
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
            case 0:
                return pickerData[row]
            
            case 1:
                switch selectMajor1 {
                    case "인문계열":
                        return majorName1[row]
                    case "사회계열":
                        return majorName2[row]
                    case "교육계열":
                        return majorName3[row]
                    case "공학계열":
                        return majorName4[row]
                    case "자연계열":
                        return majorName5[row]
                    case "의약계열":
                        return majorName6[row]
                    case "예체능계열":
                        return majorName7[row]
                    default:
                        print("default")
                    return "0"
                }
            
            default:
                return "0"
        }
    }
    
    // 피커뷰에서 선택시 호출
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
            case 0:
            selectMajor1 = pickerData[row]
            
                switch row {
                    case 0 :
                        majorDetailIndex = 0
                    case 1:
                        majorDetailIndex = majorName1.count
                    case 2:
                        majorDetailIndex = majorName2.count
                    case 3:
                        majorDetailIndex = majorName3.count
                    case 4:
                        majorDetailIndex = majorName4.count
                    case 5:
                        majorDetailIndex = majorName5.count
                    case 6:
                        majorDetailIndex = majorName6.count
                    case 7:
                        majorDetailIndex = majorName7.count
                    default:
                        print("default")
                }
            
            majorDetailPickerView.delegate = self
            majorDetailPickerView.dataSource = self
            case 1:
                switch selectMajor1 {
                    case "인문계열":
                        selectMajor2 = majorName1[row]
                    case "사회계열":
                        selectMajor2 = majorName2[row]
                    case "교육계열":
                        selectMajor2 = majorName3[row]
                    case "공학계열":
                        selectMajor2 = majorName4[row]
                    case "자연계열":
                        selectMajor2 = majorName5[row]
                    case "의약계열":
                        selectMajor2 = majorName6[row]
                    case "예체능계열":
                        selectMajor2 = majorName7[row]
                    default:
                        print("default")
                }
            default:
                print("default")
        }
    }
}
