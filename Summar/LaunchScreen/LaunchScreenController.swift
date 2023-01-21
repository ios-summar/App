//
//  LaunchScreenController.swift
//  Summar
//
//  Created by mac on 2023/01/02.
//

import Foundation
import UIKit

class LaunchScreenController: UIViewController {
    
    var mainVC : UIViewController!
    
    let imageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "SplashImage")
        view.alpha = 0.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.launchScreenBackGroundColor
        self.view.addSubview(imageView)
        
        _ = [imageView].map {
            self.view.addSubview($0)
        }
        
        imageView.snp.makeConstraints{(make) in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(75)
            make.width.equalTo(240)
        }
        
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 1.0
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()){ //+ 2.0){ //TEST
            if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(HomeController.shared, animated: true)
            }else {
                self.navigationController?.pushViewController(SocialLoginController.shared, animated: true)
            }
        }
    }
}
