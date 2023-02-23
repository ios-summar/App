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
    let fontManager = FontManager()
    let feedViewModel = FeedDetailViewModel()
    
    var param: [String: Any]?
    
    let imageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "SplashImage")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.alpha = 0.0
        return view
    }()
    lazy var splashLabel: UILabel = {
        let label = UILabel()
        label.text = "나만의 커리어를 위한 포트폴리오 제작 플랫폼"
        label.textColor = .white
        label.font = self.fontManager.getFont(Font.Regular.rawValue).mediumFont
        label.sizeToFit()
        label.alpha = 0.0
        return label
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
        self.view.addSubview(splashLabel)
    }
    
    func setAttributes() {
        
        imageView.snp.makeConstraints {
            
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.snp.centerY).offset(-20)
            $0.height.equalTo(40)
            $0.width.equalTo(200)
        }
        splashLabel.snp.makeConstraints {
            
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(10)
        }
    }
    
    private func setAnimate() {
        
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 1.0
            self.splashLabel.alpha = 1.0
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){ //TEST
            guard let _ = UserDefaults.standard.dictionary(forKey: "UserInfo") else{
                self.navigationController?.pushViewController(SocialLoginController(), animated: true)
                return
            }
            let VC = HomeController()
                
            VC.param = self.param
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(VC, animated: true)
        }
    }
}
