//
//  SceneDelegate.swift
//  Summar
//
//  Created by ukBook on 2022/09/08.
//

import UIKit
import NaverThirdPartyLogin
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    var mainVC : UIViewController?
    
//    let imageView : UIImageView = {
//        let view = UIImageView()
//        view.image = UIImage(systemName: "SplashImage")
//        view.layer.borderWidth = 1
//        view.backgroundColor = .systemPurple
//        return view
//    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        
        imageView.frame = UIScreen.main.bounds
        
        window?.rootViewController?.view.addSubview(imageView)
        window?.rootViewController?.view.bringSubviewToFront(imageView)
        
        
        
        // safeArea BackgroundColor가 Black이 되는것을 방지
        window?.safeAreaLayoutGuide.owningView?.backgroundColor = .white
        
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
            mainVC = HomeController()
        }else {
            mainVC = SocialLoginController()

        }

        let navigationController = UINavigationController(rootViewController: mainVC!)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("URLContexts.first?.url => \n", URLContexts.first?.url)
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) { // 카카오 로그인 처리
                _ = AuthController.handleOpenUrl(url: url)
            }else { // 네이버 로그인 처리
                instance?.receiveAccessToken(URLContexts.first?.url)
            }
        }
        
        

//        guard let scheme = URLContexts.first?.url.scheme else { return }
//        if scheme.contains("com.googleusercontent.apps") {
//            GIDSignIn.sharedInstance.handle(URLContexts.first!.url)
//        }
    }
    
    func changeRootVC(_ vc:UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = vc // 전환
        
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
      }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

