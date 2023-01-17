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
    
    let label : UILabel = {
        let label = UILabel()
        label.text = "나만의 커리어를 위한 포트폴리오 제작 플랫폼"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.alpha = 0.0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.launchScreenBackGroundColor
        self.view.addSubview(imageView)
        self.view.addSubview(label)
        
        _ = [imageView, label].map {
            self.view.addSubview($0)
        }
        
        imageView.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(200)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.centerY).offset(-30)
        }
        
        label.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 1.0
            self.label.alpha = 1.0
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
