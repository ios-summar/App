//
//  AppDelegate.swift
//  Summar
//
//  Created by ukBook on 2022/09/08.
//

// 구글 클라이언트 ID
// 127377779027-m9qhbusr0f0goqbqlfrh6a0boifnsb9k.apps.googleusercontent.com

import UIKit
import AuthenticationServices // 애플 로그인 https://huisoo.tistory.com/3
import IQKeyboardManagerSwift
import NaverThirdPartyLogin
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import Firebase // Push https://developer-fury.tistory.com/53
import AlamofireNetworkActivityIndicator // https://swiftpackageindex.com/Alamofire/AlamofireNetworkActivityIndicator

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        IQKeyboardManagerInit()
        KakaoLoginInit()
        NaverLoginInit()
        PushInit()
        AlamofireIndicator()
        
//        UITabBar.appearance().barTintColor = UIColor.summarColor1
        UITabBar.appearance().backgroundColor = UIColor.white
        
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//            appleIDProvider.getCredentialState(forUserID: /* 로그인에 사용한 User Identifier */) { (credentialState, error) in
//                switch credentialState {
//                case .authorized:
//                    // The Apple ID credential is valid.
//                    print("해당 ID는 연동되어있습니다.")
//                case .revoked
//                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                    print("해당 ID는 연동되어있지않습니다.")
//                case .notFound:
//                    // The Apple ID credential is either was not found, so show the sign-in UI.
//                    print("해당 ID를 찾을 수 없습니다.")
//                default:
//                    break
//                }
//            }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        return true
    }
    
    func AlamofireIndicator() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
    
    func PushInit() {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
    }
    
    func IQKeyboardManagerInit() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func KakaoLoginInit() {
        KakaoSDK.initSDK(appKey: "c82291c69573fe735c2c917069993cd9")
    }
    
    func NaverLoginInit() {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isNaverAppOauthEnable = true //네이버앱 로그인 설정
        instance?.isInAppOauthEnable = true //사파리 로그인 설정
        instance?.isOnlyPortraitSupportedInIphone() //인증 화면을 iPhone의 세로 모드에서만 사용하기
        instance?.serviceUrlScheme = "summar" //URL Scheme
        instance?.consumerKey = "vhRSDiuXtzI9d8oPXZL6" //클라이언트 아이디
        instance?.consumerSecret = "Jop9G0kyP8" //시크릿 아이디
        instance?.appName = "summar" //앱이름
    }
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("[Log] deviceToken :", deviceTokenString)
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {return}
        print("fcmToken => \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "deviceToken")
        let dataDict: [String: String] = ["token": fcmToken]
        
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      }
    
}
