//
//  LaunchScreenController.swift
//  Summar
//
//  Created by mac on 2023/01/02.
//

import Foundation
import UIKit
import SnapKit

final class LaunchScreenController: UIViewController, ViewAttributes {
    let feedViewModel = FeedDetailViewModel()
    
    var param: [String: Any]?
    
    let imageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "SplashImage")
        view.alpha = 0.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAttributes()
        setAnimate()
    }
    
    func setUI() {
        
        self.view.backgroundColor = UIColor.launchScreenBackGroundColor
        self.view.addSubview(imageView)
    }
    
    func setAttributes() {
        
        imageView.snp.makeConstraints{(make) in
            
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(75)
            make.width.equalTo(240)
        }
    }
    
    private func setAnimate() {
        
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 1.0
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){ //TEST
            guard let value = UserDefaults.standard.dictionary(forKey: "UserInfo") else{
                self.navigationController?.pushViewController(SocialLoginController(), animated: true)
                return
            }
            let VC = HomeController()
                
            VC.param = self.param
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(VC, animated: true)
        }
    }
}
