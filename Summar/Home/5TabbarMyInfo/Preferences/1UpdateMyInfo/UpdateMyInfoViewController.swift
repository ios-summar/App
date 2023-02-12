//
//  UpdateMyInfoViewController.swift
//  Summar
//
//  Created by mac on 2023/01/10.
// https://cloverlaun.tistory.com/64 << safearea backgroundColor change

import Foundation
import UIKit
import YPImagePicker

final class UpdateMyInfoViewController: UIViewController, ImageUpdatePickerDelegate, UpdateNavigationBar{
    let viewModel = UpdateMyInfoViewModel()
    let helper = Helper()
    
    var param : Dictionary<String, Any> = [:]
    
    func openPhoto(completion: @escaping (UIImage?) -> ()) {
        var config = YPImagePickerConfiguration()
        config.library.defaultMultipleSelection = false
        config.library.mediaType = .photo // 미디어타입(사진, 사진/동영상, 동영상)
        config.library.onlySquare = true
        config.library.preselectedItems = nil
        
        config.usesFrontCamera = false
        config.showsPhotoFilters = false
        config.showsVideoTrimmer = false
        config.screens = [.library]
        config.showsCrop = .circle
//        config.library.skipSelectionsGallery = false
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            for item in items {
                switch item {
                case .photo(let photo):
                    print("photo \(photo.image)")
                    print("photo \(photo.originalImage)")
                    print("photo \(photo.modifiedImage)")
                    completion(photo.image)
                case .video(let video): // Disable
                    print(video)
                }
            }
                
                picker.dismiss(animated: true, completion: nil)
         }
          present(picker, animated: true, completion: nil)
    }
    
    let updateMyInfoView = UpdateMyInfoView()
    // MARK: - Properties
    var userInfo: UserInfo? {
        didSet {
            updateMyInfoView.userInfo = self.userInfo
        }
    }
    
    let lbNavTitle : UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        title.text = "프로필 편집"
        title.font = FontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.addSubview(updateMyInfoView)
        updateMyInfoView.snp.makeConstraints{(make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    func configureDelegate() {
        updateMyInfoView.delegate = self
        updateMyInfoView.delegateUpdate = self
    }
    
    func configureUI() {
        // MARK: - fillSafeArea, SafeArea BackGroundColor Set
        fillSafeArea(position: .top, color: .white)
        fillSafeArea(position: .left, color: .white)
        fillSafeArea(position: .right, color: .white)
        fillSafeArea(position: .bottom, color: .white)
        
        // MARK: - NavigationBar
        self.navigationItem.titleView = lbNavTitle
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(popScreen), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButtonLabel(self, action: #selector(updateProfile), title: "완료", tintColor: UIColor.magnifyingGlassColor)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
                    NSAttributedString.Key.font: FontManager.getFont(Font.SemiBold.rawValue).medium15Font,
                    NSAttributedString.Key.foregroundColor: UIColor.magnifyingGlassColor],
                for: .normal)
        
        // MARK: - addView
    }
    
    func updateNavigationBar() {
        smLog("")
        guard let userNickname = updateMyInfoView.nickNameTextField.text else {return}
        guard let major1 = updateMyInfoView.editMajor.text else {return}
        guard let major2 = updateMyInfoView.majorTextField.text else {return}
        
        smLog("\(updateMyInfoView.nicknameValid)")
        smLog("\(major1.isEmpty)")
        smLog("\(major2.isEmpty)")
        
        if updateMyInfoView.nicknameValid && !major1.isEmpty && !major2.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc func popScreen(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func updateProfile(){
        smLog("")
        var userInfoUserDefaults = UserDefaults.standard.dictionary(forKey: "UserInfo")
        
        let profileImage = updateMyInfoView.profileImageView.image
        let userNickname = updateMyInfoView.nickNameTextField.text
        let major1 = updateMyInfoView.editMajor.text
        let major2 = updateMyInfoView.majorTextField.text
        let introduce = updateMyInfoView.view2TextView.text
        LoadingIndicator.showLoading()
        
        param["userNickname"] = userInfo?.result.userNickname
        param["updateUserNickname"] = userNickname
        param["major1"] = major1
        param["major2"] = major2
        
        
        if profileImage == UIImage(named: "NonProfile") {
            smLog("")
            param["profileImageUrl"] = ""
        }else {
            smLog("")
            param["profileImageUrl"] = profileImage
        }
        
        if introduce == "나에 대해 소개해 주세요" {
            param["introduce"] = ""
        }else {
            param["introduce"] = introduce
        }
        
        print("!! ",param)
        
        viewModel.updateUserInfo(param)
        
        viewModel.didFinishFetch = {
            userInfoUserDefaults!["userNickname"] = userNickname
            userInfoUserDefaults!["major1"] = major1
            userInfoUserDefaults!["major2"] = major2
            UserDefaults.standard.set(userInfoUserDefaults!, forKey: "UserInfo")
            
            toast("프로필 편집 완료")
            self.navigationController?.popViewController(animated: true)
        }
            
    }
}
