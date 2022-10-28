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
    func moveSignUp2() {
        progressBar.progress = 1.0
        animation(viewAnimation: signUp1View)
    }
    
    let progressBar : UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.trackTintColor = .lightGray
        progressBar.progressTintColor = UIColor.summarColor2
        progressBar.progress = 0.5
        return progressBar
    }()
    
    let signUp1View = SignUp1View()
    let signUp2View = SignUp2View()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signUp1View)
        view.addSubview(progressBar)
//        view.addSubview(signUp2View)
        signUp1View.delegate = self
        
        layoutInit()
    }
    
    func layoutInit() {
        progressBar.snp.makeConstraints{(make) in
            make.topMargin.equalTo(20)
            make.leftMargin.equalTo(10)
            make.rightMargin.equalTo(-10)
            make.height.equalTo(5)
        }
        
        // layout
        signUp1View.snp.makeConstraints{(make) in
            make.top.equalTo(progressBar.snp.bottom).offset(20)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
    
    private func animation(viewAnimation: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            viewAnimation.frame.origin.x = -viewAnimation.frame.width
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewAnimation.removeFromSuperview()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.anima(self.signUp2View)
            }
            
        })
    }
    
    func anima(_ view: UIView){
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(view)
            
            // layout
        self.signUp2View.snp.makeConstraints{(make) in
            make.top.equalTo(self.progressBar.snp.bottom).offset(20)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
            
            self.signUp2View.frame.origin.x = -100
        }, completion: nil)
    }
 }
