//
//  UpdateMyInfoView.swift
//  Summar
//
//  Created by mac on 2023/01/10.
//

import Foundation
import UIKit

protocol ImageUpdatePickerDelegate : AnyObject {
    func openPhoto(completion: @escaping(UIImage?) -> ())
}

class UpdateMyInfoView: UIView, UITextViewDelegate {
    
    weak var delegate : ImageUpdatePickerDelegate?
    
    let helper = Helper()
    let request = ServerRequest.shared
    
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
    
    let textViewPlaceHolder = "자기소개는 2,000자 이내로 입력 가능합니다."
    
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
    
    var userInfo: UserInfo? {
        didSet {
            print("UpdateMyInfoView userInfo =>\n \(userInfo)")
            
            if let profile = userInfo?.result.profileImageUrl {
                //url에 정확한 이미지 url 주소를 넣는다.
                let url = URL(string: profile)
                //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
                //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
    //                    cell.imageView.image = UIImage(data: data!)
                        self.profileImageView.kf.indicatorType = .activity
                        self.profileImageView.kf.setImage(
                          with: url,
                          placeholder: nil,
                          options: [.transition(.fade(1.2))],
                          completionHandler: nil
                        )
                    }
                }
            }else {
                self.profileImageView.image = UIImage(named: "NonProfile")
            }
            
            if let nickname = userInfo?.result.userNickname {
                nickNameTextField.text = nickname
            }
            
            if let major1 = userInfo?.result.major1 {
                selectMajor1 = major1
                editMajor.text = major1
            }
            
            if let major2 = userInfo?.result.major2 {
                majorTextField.text = major2
            }
            
            if let introduce = userInfo?.result.introduce {
                view2TextView.text = introduce
            }
        }
    }
    
    lazy var profileImageView : UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        
        
        let change = UITapGestureRecognizer(target: self, action: #selector(changeProfile))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(change)
        return view
    }()
    
    
    let nickNameTextField : UITextField = {
        let nickNameTextField = UITextField()
        nickNameTextField.translatesAutoresizingMaskIntoConstraints = false
        nickNameTextField.layer.borderWidth = 1
        nickNameTextField.layer.borderColor = UIColor.white.cgColor
        nickNameTextField.backgroundColor = UIColor.textFieldColor
        nickNameTextField.layer.cornerRadius = 4
        nickNameTextField.placeholder = "영문 또는 한글 2~8자"
        nickNameTextField.attributedPlaceholder = NSAttributedString(string: "영문 또는 한글 2~8자", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor205])
        nickNameTextField.addLeftPadding()
        nickNameTextField.font = .systemFont(ofSize: 15)
        nickNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nickNameTextField.textColor = .black
        return nickNameTextField
    }()
    
    let nicknameCheckBtn : UIButton = {
        let btn = UIButton()
        btn.layer.borderWidth = 1
        btn.setTitle("중복확인", for: .normal)
        btn.isEnabled = false
        btn.backgroundColor = .grayColor205
        return btn
    }()
    
    let editMajor : UITextField = {
        let editMajor = UITextField()
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
    
    let view2 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.textFieldColor
        return view
    }()
    
    lazy var view2TextView : UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.textFieldColor
        textView.font = .systemFont(ofSize: 18)
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        textView.delegate = self
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        pickerViewInit()
        
        _ = [profileImageView, nickNameTextField, nicknameCheckBtn, editMajor, majorTextField, view2].map{
            addSubview($0)
        }
        view2.addSubview(view2TextView)
        
        profileImageView.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(30)
            make.width.height.equalTo(80)
        }
        
        nickNameTextField.snp.makeConstraints{(make) in
            make.left.equalTo(20)
            make.centerY.equalTo(nicknameCheckBtn.snp.centerY)
            make.right.equalTo(nicknameCheckBtn.snp.left)
            make.height.equalTo(60)
        }
        
        nicknameCheckBtn.snp.makeConstraints{(make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.right.equalTo(-20)
            make.height.equalTo(60)
            make.width.equalTo(80)
        }
        
        editMajor.snp.makeConstraints{(make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(50)
            make.top.equalTo(nickNameTextField.snp.bottom).offset(20)
        }
        
        majorTextField.snp.makeConstraints{(make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(50)
            make.top.equalTo(editMajor.snp.bottom).offset(10)
        }
        
        view2.snp.makeConstraints{(make) in
            make.top.equalTo(majorTextField.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.bottom.equalTo(-20)
        }
        
        view2TextView.snp.makeConstraints{(make) in
            make.top.left.equalTo(20)
            make.right.bottom.equalTo(-20)
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
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if (textField.text?.count ?? 0 > 8) {
            textField.deleteBackward()
        }
        
//        if textField.text?.count ?? 0 >= 1 {
//            if helper.checkNickNamePolicy(text: textField.text!) { // 한글, 영어, 숫자임
//                // GET방식으로 닉네임 중복체크
////                requestGETBOOL(requestUrl: "/user/nickname-check?userNickname=\(textField.text!)")
//                request.nicknameCheck(requestUrl: "/user/nickname-check?userNickname=\(textField.text!)") { TF, error in
//                    guard let TF = TF else { return }
//
//                    if TF {
//                        self.enableNickname(enable: false, content: "중복된 닉네임입니다.")
//                    }else{
//                        self.enableNickname(enable: true, content: "사용 가능한 닉네임입니다.")
//                    }
//                }
//            }else { // 한글, 영어, 숫자가 아님.
//                enableNickname(enable: false, content: "닉네임은 한글, 영어, 숫자만 사용 가능합니다.")
//            }
//        }else {
//            if textField.text?.count ?? 0 == 0 {
//                enableNickname(enable: false, content: nil)
//            }else {
//                enableNickname(enable: false, content: "닉네임을 두글자 이상 입력해주세요.")
//            }
//        }
    }
    
//    func enableNickname(enable: Bool, content: String?){
//        if enable {
//            self.sendBtnEnable(true)
//            nickNameEnableLabel.text = content
//            nickNameEnableLabel.textColor = .systemGreen
//            nickNameTextField.layer.borderColor = UIColor.systemGreen.cgColor
//        }else {
//            self.sendBtnEnable(false)
//            if content != nil {
//                nickNameEnableLabel.text = content
//                nickNameEnableLabel.textColor = .systemRed
//                nickNameTextField.layer.borderColor = UIColor.systemRed.cgColor
//            }else {
//                nickNameEnableLabel.text = ""
//                nickNameEnableLabel.textColor = .white
//                nickNameTextField.layer.borderColor = UIColor.white.cgColor
//            }
//        }
//    }
    
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
        
//        if editMajor.text?.isEmpty ?? true || majorTextField.text?.isEmpty ?? true{
//            self.sendBtnEnable(false)
//        }else {
//            self.sendBtnEnable(true)
//        }
    }
    
    // 피커뷰 > 취소 클릭
    @objc func onPickCancel1() {
        majorTextField.resignFirstResponder() // 피커뷰를 내림 (텍스트필드가 responder 상태를 읽음)
//        selectMajor2 = ""
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
    
    
    @objc func changeProfile(sender: UITapGestureRecognizer) {
        self.delegate?.openPhoto(completion: { photo in
            print("photo => \(photo)")
            self.profileImageView.image = photo
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UpdateMyInfoView : UIPickerViewDelegate, UIPickerViewDataSource {
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
