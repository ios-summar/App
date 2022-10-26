//
//  SignUp1Controller.swift
//  Summar
//
//  Created by ukBook on 2022/10/23.
//

import Foundation
import UIKit
import SnapKit

class SignUp1Controller : UIViewController, Delegate {
    func moveSignUp2() {
        progressBar.progress = 0.66666666
        animation(viewAnimation: signUp1View)
    }
    
    
    let progressBar : UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.trackTintColor = .lightGray
        progressBar.progressTintColor = UIColor.summarColor2
        progressBar.progress = 0.33333333
        return progressBar
    }()
    
    func pushView(storyboard: String, controller: String) {
//        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: controller)
//        self.navigationController?.pushViewController(vc, animated: true)
        UIView.animate(withDuration: 0.5, animations: {
            self.signUp1View.alpha = 0
        })
    }
    
    let signUp1View = SignUp1View()
    let signUp2View = SignUp2View()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signUp1View)
        view.addSubview(progressBar)
        view.addSubview(signUp2View)
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
        })
        
        UIView.animate(withDuration: 0.5, animations: {
                self.signUp2View.frame.origin.x = -self.signUp2View.frame.width
            
            // layout
            self.signUp2View.snp.makeConstraints{(make) in
                make.top.equalTo(self.progressBar.snp.bottom).offset(20)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(0)
            }
        })
        
//        { (_) in
//            UIView.animate(withDuration: 2, delay: 1, options: [.curveEaseIn], animations: {
//                viewAnimation.frame.origin.x -= viewAnimation.frame.width
//            })
//
//        }
    }
    
    func anima(_ view: UIView){
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(view)
        }, completion: nil)

//        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
//          subview.removeFromSuperview()
//        }, completion: nil)
    }
 }
