//
//  SignUp1View.swift
//  Summar
//
//  Created by ukBook on 2022/10/23.
//

import Foundation
import UIKit
import SnapKit

class SignUp1View : UIView {
    
    let helper = Helper()
    var checkboxArr = [false, false, false, false]

    let viewWidth : CGFloat = {
        // 뷰 전체 폭 길이
        var screenWidth = UIScreen.main.bounds.size.width
        var divScreen = screenWidth / 3 - 30
        return divScreen
    }()
    
    let bottomBtnWidth : CGFloat = {
        var screenWidth = UIScreen.main.bounds.size.width
        return screenWidth / 2 - 30
    }()
    
    let viewLine1 : UIView = {
        let viewLine1 = UIView()
        viewLine1.translatesAutoresizingMaskIntoConstraints = false
        viewLine1.backgroundColor = UIColor.summarColor2
        return viewLine1
    }()
    
    let viewLine2 : UIView = {
        let viewLine2 = UIView()
        viewLine2.translatesAutoresizingMaskIntoConstraints = false
        viewLine2.backgroundColor = UIColor.grayColor205
        return viewLine2
    }()
    
    let viewLine3 : UIView = {
        let viewLine3 = UIView()
        viewLine3.translatesAutoresizingMaskIntoConstraints = false
        viewLine3.backgroundColor = UIColor.grayColor205
        return viewLine3
    }()
    
    var checkboxAll : UIImageView = {
        let checkboxAll = UIImageView()
        checkboxAll.translatesAutoresizingMaskIntoConstraints = false
        checkboxAll.image = UIImage(systemName: "square") //checkmark.square
        checkboxAll.tintColor = UIColor.grayColor197
        checkboxAll.tag = 1
        return checkboxAll
    }()
    
    var checkboxAllBtn : UIButton = {
        let checkboxAllBtn = UIButton()
        checkboxAllBtn.translatesAutoresizingMaskIntoConstraints = false
        checkboxAllBtn.setTitle("전체 약관동의", for: .normal)
        checkboxAllBtn.setTitleColor(.black, for: .normal)
        checkboxAllBtn.titleLabel?.font = .systemFont(ofSize: 18)
        checkboxAllBtn.sizeToFit()
        checkboxAllBtn.tag = 2
        return checkboxAllBtn
    }()
    
    var checkbox1 : UIImageView = {
        let checkbox1 = UIImageView()
        checkbox1.translatesAutoresizingMaskIntoConstraints = false
        checkbox1.image = UIImage(systemName: "square") //checkmark.square
        checkbox1.tintColor = UIColor.grayColor197
        checkbox1.tag = 11
        return checkbox1
    }()
    
    let checkboxBtn1 : UIButton = {
        let checkboxBtn1 = UIButton()
        checkboxBtn1.translatesAutoresizingMaskIntoConstraints = false
        checkboxBtn1.setTitle("[필수] 써머 이용약관", for: .normal)
        checkboxBtn1.setTitleColor(.black, for: .normal)
        checkboxBtn1.titleLabel?.font = .systemFont(ofSize: 15)
        checkboxBtn1.sizeToFit()
        checkboxBtn1.tag = 12
        return checkboxBtn1
    }()
    
    let contentBtn1 : UIButton = {
        let contentBtn1 = UIButton()
        contentBtn1.translatesAutoresizingMaskIntoConstraints = false
        contentBtn1.setTitle("내용보기", for: .normal)
        contentBtn1.setTitleColor(UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1), for: .normal)
        contentBtn1.titleLabel?.font = .systemFont(ofSize: 13)
        contentBtn1.sizeToFit()
        contentBtn1.tag = 13
        return contentBtn1
    }()
    
    let viewLine4 : UIView = {
        let viewLine1 = UIView()
        viewLine1.translatesAutoresizingMaskIntoConstraints = false
        viewLine1.backgroundColor = UIColor.grayColor197
        return viewLine1
    }()
    
    var checkbox2 : UIImageView = {
        let checkbox2 = UIImageView()
        checkbox2.translatesAutoresizingMaskIntoConstraints = false
        checkbox2.image = UIImage(systemName: "square") //checkmark.square
        checkbox2.tintColor = UIColor.grayColor197
        checkbox2.tag = 21
        return checkbox2
    }()
    
    let checkboxBtn2 : UIButton = {
        let checkboxBtn2 = UIButton()
        checkboxBtn2.translatesAutoresizingMaskIntoConstraints = false
        checkboxBtn2.setTitle("[필수] 개인정보수집동의", for: .normal)
        checkboxBtn2.setTitleColor(.black, for: .normal)
        checkboxBtn2.titleLabel?.font = .systemFont(ofSize: 15)
        checkboxBtn2.sizeToFit()
        checkboxBtn2.tag = 22
        return checkboxBtn2
    }()
    
    let contentBtn2 : UIButton = {
        let contentBtn2 = UIButton()
        contentBtn2.translatesAutoresizingMaskIntoConstraints = false
        contentBtn2.setTitle("내용보기", for: .normal)
        contentBtn2.setTitleColor(UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1), for: .normal)
        contentBtn2.titleLabel?.font = .systemFont(ofSize: 13)
        contentBtn2.sizeToFit()
        contentBtn2.tag = 23
        return contentBtn2
    }()
    
    let viewLine5 : UIView = {
        let viewLine1 = UIView()
        viewLine1.translatesAutoresizingMaskIntoConstraints = false
        viewLine1.backgroundColor = UIColor.grayColor197
        return viewLine1
    }()
    
    var checkbox3 : UIImageView = {
        let checkbox3 = UIImageView()
        checkbox3.translatesAutoresizingMaskIntoConstraints = false
        checkbox3.image = UIImage(systemName: "square") //checkmark.square
        checkbox3.tintColor = UIColor.grayColor197
        checkbox3.tag = 31
        return checkbox3
    }()
    
    let checkboxBtn3 : UIButton = {
        let checkboxBtn3 = UIButton()
        checkboxBtn3.translatesAutoresizingMaskIntoConstraints = false
        checkboxBtn3.setTitle("[선택] 마케팅 정보 수신 약관", for: .normal)
        checkboxBtn3.setTitleColor(.black, for: .normal)
        checkboxBtn3.titleLabel?.font = .systemFont(ofSize: 15)
        checkboxBtn3.sizeToFit()
        checkboxBtn3.tag = 32
        return checkboxBtn3
    }()
    
    let contentBtn3 : UIButton = {
        let contentBtn3 = UIButton()
        contentBtn3.translatesAutoresizingMaskIntoConstraints = false
        contentBtn3.setTitle("내용보기", for: .normal)
        contentBtn3.setTitleColor(UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1), for: .normal)
        contentBtn3.titleLabel?.font = .systemFont(ofSize: 13)
        contentBtn3.sizeToFit()
        contentBtn3.tag = 33
        return contentBtn3
    }()
    
    let viewLine6 : UIView = {
        let viewLine1 = UIView()
        viewLine1.translatesAutoresizingMaskIntoConstraints = false
        viewLine1.backgroundColor = UIColor.grayColor197
        return viewLine1
    }()
    
    let previousBtn : UIButton = {
        let previousBtn = UIButton()
        previousBtn.translatesAutoresizingMaskIntoConstraints = false
        previousBtn.backgroundColor = .white
        previousBtn.layer.borderColor = UIColor.summarColor2.cgColor
        previousBtn.layer.borderWidth = 2
        previousBtn.layer.cornerRadius = 4
        previousBtn.setTitle("이전", for: .normal)
        previousBtn.setTitleColor(UIColor.summarColor2, for: .normal)
        previousBtn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        previousBtn.tag = 41
        return previousBtn
    }()
    
    let nextBtn : UIButton = {
        let nextBtn = UIButton()
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.backgroundColor = UIColor.summarColor2
        nextBtn.layer.cornerRadius = 4
        nextBtn.layer.borderWidth = 2
        nextBtn.layer.borderColor = UIColor.summarColor2.cgColor
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        nextBtn.tag = 42
        return nextBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //btn click Action
        btnAddTarget()
        
        addSubview(viewLine1)
        addSubview(viewLine2)
        addSubview(viewLine3)
        
        addSubview(checkboxAll)
        addSubview(checkboxAllBtn)
        
        addSubview(checkbox1)
        addSubview(checkboxBtn1)
        addSubview(contentBtn1)
        addSubview(viewLine4)
        
        addSubview(checkbox2)
        addSubview(checkboxBtn2)
        addSubview(contentBtn2)
        addSubview(viewLine5)
        
        addSubview(checkbox3)
        addSubview(checkboxBtn3)
        addSubview(contentBtn3)
        addSubview(viewLine6)
        
        addSubview(nextBtn)
        addSubview(previousBtn)
        
        
        // 상단 프로세스 바
        viewLine2.snp.makeConstraints {(make) in
            make.topMargin.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(viewWidth)
            make.height.equalTo(2)
        }
        
        viewLine1.snp.makeConstraints {(make) in
            make.centerY.equalTo(viewLine2.snp.centerY)
            make.rightMargin.equalTo(viewLine2.snp.left).offset(-20)
            make.width.equalTo(viewWidth)
            make.height.equalTo(2)
        }
        
        viewLine3.snp.makeConstraints {(make) in
            make.centerY.equalTo(viewLine2.snp.centerY)
            make.leftMargin.equalTo(viewLine2.snp.right).offset(20)
            make.width.equalTo(viewWidth)
            make.height.equalTo(2)
        }
        //
        
        // 전체 약관동의
        checkboxAll.snp.makeConstraints{(make) in
            make.topMargin.equalTo(viewLine1).offset(62)
            make.leftMargin.equalTo(25)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }

        checkboxAllBtn.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkboxAll.snp.centerY)
            make.leftMargin.equalTo(checkboxAll.snp.right).offset(20)
            make.height.equalTo(19)
        }
        //
        
        //[필수] 써머 이용약관
        checkbox1.snp.makeConstraints{(make) in
            make.topMargin.equalTo(checkboxAll.snp.bottom).offset(40)
            make.leftMargin.equalTo(35)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        checkboxBtn1.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkbox1.snp.centerY)
            make.leftMargin.equalTo(checkbox1.snp.right).offset(20)
            make.height.equalTo(8)
        }
        
        contentBtn1.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkboxBtn1.snp.centerY)
            make.rightMargin.equalTo(-52)
            make.height.equalTo(14)
        }
        
        viewLine4.snp.makeConstraints{(make) in
            make.topMargin.equalTo(checkboxBtn1.snp.bottom).offset(30)
            make.leftMargin.equalTo(35)
            make.rightMargin.equalTo(-35)
            make.height.equalTo(1)
        }
        //
        
        //[필수] 개인정보 수집 및 이용에 대한 안내
        checkbox2.snp.makeConstraints{(make) in
            make.topMargin.equalTo(viewLine4.snp.bottom).offset(40)
            make.leftMargin.equalTo(35)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        checkboxBtn2.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkbox2.snp.centerY)
            make.leftMargin.equalTo(checkbox2.snp.right).offset(20)
            make.height.equalTo(8)
        }

        contentBtn2.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkboxBtn2.snp.centerY)
            make.rightMargin.equalTo(-52)
            make.height.equalTo(14)
        }

        viewLine5.snp.makeConstraints{(make) in
            make.topMargin.equalTo(checkboxBtn2.snp.bottom).offset(30)
            make.leftMargin.equalTo(35)
            make.rightMargin.equalTo(-35)
            make.height.equalTo(1)
        }
        //
        
        //[선택] 마케팅 정보 수신 약관
        checkbox3.snp.makeConstraints{(make) in
            make.topMargin.equalTo(viewLine5.snp.bottom).offset(40)
            make.leftMargin.equalTo(35)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        checkboxBtn3.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkbox3.snp.centerY)
            make.leftMargin.equalTo(checkbox3.snp.right).offset(20)
            make.height.equalTo(8)
        }

        contentBtn3.snp.makeConstraints{(make) in
            make.centerY.equalTo(checkboxBtn3.snp.centerY)
            make.rightMargin.equalTo(-52)
            make.height.equalTo(14)
        }

        viewLine6.snp.makeConstraints{(make) in
            make.topMargin.equalTo(checkboxBtn3.snp.bottom).offset(30)
            make.leftMargin.equalTo(35)
            make.rightMargin.equalTo(-35)
            make.height.equalTo(1)
        }
        //
        
        previousBtn.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(-20)
            make.leftMargin.equalTo(20)
            make.rightMargin.equalTo(self.safeAreaLayoutGuide.snp.centerX).offset(-20)
            make.height.equalTo(52)
        }
        
        nextBtn.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(-20)
            make.rightMargin.equalTo(-20)
            make.leftMargin.equalTo(self.safeAreaLayoutGuide.snp.centerX).offset(20)
            make.height.equalTo(52)
        }
    }
    
    func btnAddTarget(){
        checkboxAllBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        checkboxBtn1.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        contentBtn1.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        checkboxBtn2.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        contentBtn2.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        checkboxBtn3.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        contentBtn3.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        previousBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        
        let tapGesture0 = UITapGestureRecognizer(target: self, action: #selector(btnAction(_:)))
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(btnAction(_:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(btnAction(_:)))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(btnAction(_:)))
        
        checkboxAll.addGestureRecognizer(tapGesture0)
        checkbox1.addGestureRecognizer(tapGesture1)
        checkbox2.addGestureRecognizer(tapGesture2)
        checkbox3.addGestureRecognizer(tapGesture3)
        
        checkboxAll.isUserInteractionEnabled = true
        checkbox1.isUserInteractionEnabled = true
        checkbox2.isUserInteractionEnabled = true
        checkbox3.isUserInteractionEnabled = true
        

    }
    
    @objc func btnAction(_ sender : Any){
//        print((sender as AnyObject).tag)
//        print((sender as? UITapGestureRecognizer)?.view?.tag)
        
        if let tagNum = (sender as AnyObject).tag {
//            print(tagNum)
            switch tagNum {
            // 체크박스 옆 버튼
            case 2:
                print("전체약관동의")
                checkBoxToggle(index: 0)
            case 12:
                print("[필수] 써머 이용약관")
                checkBoxToggle(index: 1)
            case 22:
                print("[필수] 개인정보수집동의")
                checkBoxToggle(index: 2)
            case 32:
                print("[선택] 마케팅 정보 수신 약관")
                checkBoxToggle(index: 3)
                
            // 내용 보기
            case 13:
                print("[필수] 써머 이용약관 내용보기")
            case 23:
                print("[필수] 개인정보수집동의 내용보기")
            case 33:
                print("[선택] 마케팅 정보 수신 약관 내용보기")
                
            // 하단 버튼
            case 41:
                print("이전")
            case 42:
                nextPage()
            default:
                print("default")
            }
        }else if let tagNum = (sender as? UITapGestureRecognizer)?.view?.tag {
            switch tagNum {
            case 1:
                checkBoxToggle(index: 0)
            case 11:
                checkBoxToggle(index: 1)
            case 21:
                checkBoxToggle(index: 2)
            case 31:
                checkBoxToggle(index: 3)
            default:
                print("default")
            }
        }
            
    }
    
    func nextPage(){
        for x in 1 ... 2 {
            if !checkboxArr[x] { // 필수 약관동의 X
                helper.showAlert(vc: self, message: "필수 약관에 동의하셔야 회원가입이 가능합니다.")
                return
            }
        }
        print("화면 이동")
    }
    
    func checkBoxToggle(index : Int){
        // 1. true / false 값 변환
        // 2. true / false 값으로 전체동의 박스도 확인
        // 3. 이미지 변환 square(빈박스) <-> checkmark.square(체크박스)
        
        let imageViewArr = [checkboxAll, checkbox1, checkbox2, checkbox3]
        
        // 1. true / false 값 변환
        if checkboxArr[index] {
            checkboxArr[index] = false
        }else {
            checkboxArr[index] = true
        }
        
        if index == 0 { // 전체 약관동의
            if checkboxArr[0] { // 빈박스에서 박스채우기
                checkboxArr[0] = true
                checkboxArr[1] = true
                checkboxArr[2] = true
                checkboxArr[3] = true
                
                changeImage(nil, imageViewArr, true)
            }else { // 체크박스에서 빈박스로
                checkboxArr[0] = false
                checkboxArr[1] = false
                checkboxArr[2] = false
                checkboxArr[3] = false
                
                changeImage(nil, imageViewArr, false)
            }
        }else {
            if checkboxArr[index] {
                if checkboxArr[1] && checkboxArr[2] && checkboxArr[3] {
                    checkboxArr[0] = true
                    checkboxArr[1] = true
                    checkboxArr[2] = true
                    checkboxArr[3] = true
                    
                    changeImage(nil, imageViewArr, true)
                }else {
                    checkboxArr[index] = true
                    changeImage(imageViewArr[index], nil, true)
                }
            }else {
                if !checkboxArr[1] && !checkboxArr[2] && !checkboxArr[3] {
                    checkboxArr[0] = false
                    checkboxArr[1] = false
                    checkboxArr[2] = false
                    checkboxArr[3] = false
                    
                    changeImage(nil, imageViewArr, false)
                }else {
                    checkboxArr[0] = false
                    checkboxArr[index] = false
                    changeImage(imageViewArr[0], nil, false)
                    changeImage(imageViewArr[index], nil, false)
                }
            }
        }
    }
    
    /// ImageView 변경 함수
    /// - Parameters:
    ///   - uiImageView: uiImageView => 해당 함수인자가 값이 있을때 해당 이미지뷰 이미지 변경
    ///   - uiImageViewArr: imageView 배열 => 해당 함수인자가 nil이 아닐때 전체 체크, 전체 '미'체크
    ///   - index: true / false 값으로 checkmark.square <-> square 변경
    func changeImage(_ uiImageView: UIImageView?,_ uiImageViewArr: [UIImageView]? , _ index : Bool){
        
        if let uiImageViewArr = uiImageViewArr { // 전체 약관동의
            if index { // 이미지 변환 square -> checkmark.square
                for x in 0 ... uiImageViewArr.count - 1 {
                    uiImageViewArr[x].image = UIImage(systemName: "checkmark.square")
                    uiImageViewArr[x].tintColor = .black
                }
            }else { // 이미지 변환 checkmark.square -> square
                for x in 0 ... uiImageViewArr.count - 1 {
                    uiImageViewArr[x].image = UIImage(systemName: "square")
                    uiImageViewArr[x].tintColor = UIColor.grayColor197
                }
            }
        }else { // 그 이외
            if index { // 이미지 변환 square -> checkmark.square
                uiImageView?.image = UIImage(systemName: "checkmark.square")
                uiImageView?.tintColor = .black
            }else { // 이미지 변환 checkmark.square -> square
                uiImageView?.image = UIImage(systemName: "square")
                uiImageView?.tintColor = UIColor.grayColor197
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
