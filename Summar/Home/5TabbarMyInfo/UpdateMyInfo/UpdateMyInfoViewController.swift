//
//  UpdateMyInfoViewController.swift
//  Summar
//
//  Created by mac on 2023/01/10.
//

import Foundation
import UIKit
import YPImagePicker

class UpdateMyInfoViewController: UIViewController, ImageUpdatePickerDelegate {
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
        title.text = "회원정보수정"
        title.font = .boldSystemFont(ofSize: 20)
        title.textColor = UIColor.summarColor1
        title.sizeToFit()
        return title
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMyInfoView.delegate = self
        // MARK: - 상단 타이틀, 버튼
        self.navigationItem.titleView = lbNavTitle
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(popScreen), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(myInfoUpdate), uiImage: UIImage(systemName: "checkmark")!, tintColor: .black)
        self.navigationItem.rightBarButtonItem?.tintColor = .black
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
    
    @objc func popScreen(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func myInfoUpdate(){
        smLog("")
    }
}
