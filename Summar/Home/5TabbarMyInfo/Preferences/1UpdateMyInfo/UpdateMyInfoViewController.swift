//
//  UpdateMyInfoViewController.swift
//  Summar
//
//  Created by mac on 2023/01/10.
// https://cloverlaun.tistory.com/64 << safearea backgroundColor change

import Foundation
import UIKit
import YPImagePicker

class UpdateMyInfoViewController: UIViewController, ImageUpdatePickerDelegate {
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
    
    static let shared = UpdateMyInfoViewController()
    
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
        title.font = .boldSystemFont(ofSize: 20)
        title.textColor = UIColor.summarColor1
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(updateProfile))
//        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        // MARK: - addView
    }
    
    @objc func popScreen(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func updateProfile(){
        smLog("")
        
        LoadingIndicator.showLoading()
        
        let profileImage = updateMyInfoView.profileImageView.image
        let userNickname = updateMyInfoView.nickNameTextField.text
        let major1 = updateMyInfoView.editMajor.text
        let major2 = updateMyInfoView.majorTextField.text
        let introduce = updateMyInfoView.view2TextView.text
        
        if !updateMyInfoView.nicknameValid {
            helper.showAlertAction(vc: self, message: "닉네임 중복 확인 후 프로필 편집이 가능합니다.")
        }else if major1!.isEmpty && major2!.isEmpty {
            helper.showAlertAction(vc: self, message: "전공을 선택 후 프로필 편집이 가능합니다.")
        }else { // 정규식 이상 없음
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
                self.navigationController?.popViewController(animated: true)
                self.helper.showAlertAction(vc: self, message: "프로필 편집을 완료했습니다.")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                LoadingIndicator.hideLoading()
            }
        }
    }
}
