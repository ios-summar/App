//
//  SignUpController.swift
//  Summar
//
//  Created by ukBook on 2022/10/23.
//

import Foundation
import UIKit
import SnapKit

class SignUpController : UIViewController, signUp1Delegate{
    
    let helper : Helper = Helper()
    
    func sendBtnEnable(_ TF: Bool) {
        if TF {
            sendBtn.isEnabled = true
            sendBtn.backgroundColor = UIColor.summarColor2
        }else {
            sendBtn.isEnabled = false
            sendBtn.backgroundColor = UIColor.grayColor205
        }
    }
    
    let progressBar : UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.trackTintColor = .lightGray
        progressBar.progressTintColor = UIColor.summarColor2
        progressBar.progress = 0.5
        return progressBar
    }()
    
    let sendBtn : UIButton = {
        let sendBtn = UIButton()
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.setTitle("다음", for: .normal)
        sendBtn.setTitleColor(.white, for: .normal)
        sendBtn.titleLabel?.font = .systemFont(ofSize: 15)
        sendBtn.backgroundColor = UIColor.grayColor205
        sendBtn.layer.cornerRadius = 4
        sendBtn.isEnabled = false
        sendBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        return sendBtn
    }()
    
    let signUp1View = SignUp1View()
    let signUp2View = SignUp2View()
    
    var nickName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signUp1View)
        view.addSubview(sendBtn)
        view.addSubview(progressBar)
//        view.addSubview(signUp2View)
        signUp1View.delegate = self

        helper.showAlertAction(vc: self, message: "회원정보가 없어\n회원가입 화면으로 이동합니다.")
        
        layoutInit()
    }
    
    func layoutInit() {
        progressBar.snp.makeConstraints{(make) in
            make.topMargin.equalTo(20)
            make.leftMargin.equalTo(10)
            make.rightMargin.equalTo(-10)
            make.height.equalTo(5)
        }
        
        sendBtn.snp.makeConstraints{(make) in
            make.bottomMargin.equalTo(-20)
            make.leftMargin.equalTo(20)
            make.rightMargin.equalTo(-20)
            make.height.equalTo(52)
        }

        
        // layout
        signUp1View.snp.makeConstraints{(make) in
            make.top.equalTo(progressBar.snp.bottom).offset(20)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(sendBtn.snp.top).offset(-20)
        }
    }
    
    private func animation(viewAnimation1: UIView, viewAnimation2: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            viewAnimation1.frame.origin.x = -viewAnimation1.frame.width
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewAnimation1.removeFromSuperview()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.anima(viewAnimation2)
            }
            
        })
    }
    
    func anima(_ view: UIView){
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(view)
            
            // layout
        view.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(100)
            make.bottom.equalTo(self.sendBtn.snp.top).offset(-20)
        }
            
        view.frame.origin.x = -100
            
        }, completion: nil)
    }
    
    @objc func btnAction(){
        progressBar.progress = 1.0
        animation(viewAnimation1: signUp1View, viewAnimation2: signUp2View)
    }
 }
