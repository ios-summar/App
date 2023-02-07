//
//  WriteFeed.swift
//  Summar
//
//  Created by mac on 2022/12/22.
//

import Foundation
import UIKit
import BSImagePicker
import Photos
import YPImagePicker

final class WriteFeedController : UIViewController, ImagePickerDelegate, PopDelegate{
    func popScreen() {
        closeAction()
    }
    
    var feedInfo: FeedInfo? {
        didSet {
            smLog("\(feedInfo)")
            wfView.feedInfo = self.feedInfo
        }
    }
    
    let helper = Helper()
    let wfView = WriteFeedView()
    
    var imageArr = [UIImage]()
    
    let titleLabel : UILabel = {
        let title = UILabel()
        title.text = "피드 작성"
        title.font = FontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    override func viewDidLoad() {
        configureDelegate()
        configureUI()
    }
    
    func configureDelegate() {
        wfView.delegate = self
        wfView.popDelegate = self
    }
    
    /// UI 초기설정
    func configureUI() {
        // MARK: - SafeArea or View BackGroundColor Set
        fillSafeArea(position: .top, color: .white)
        fillSafeArea(position: .left, color: .white)
        fillSafeArea(position: .right, color: .white)
        fillSafeArea(position: .bottom, color: .white)
        
        // MARK: - NavigationBar
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(closeAction), uiImage: UIImage(systemName: "xmark")!, tintColor: .black)
        // MARK: - addView
        // MARK: - Feed Body
        self.view.addSubview(wfView)
        wfView.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewWillLayoutSubviews() {
//        wfView.reset()
    }
    
    func showAlert(_ message : String) {
        helper.showAlertAction(vc: self, title: "알림", message: message)
    }
    
    @objc func closeAction() {
        wfView.reset()
        self.dismiss(animated: true, completion: nil)
    }
    
    func showImageFullScreen(_ imageArr: [UIImage]) {
        let VC = FullScreenImageViewController()
        VC.imageArr = imageArr
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil // 스와이프 제스처 enable true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    // MARK: - ImagePicker func
    func openPhoto(completion: @escaping([UIImage]?) -> ()) {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 10 // 최대 선택 가능한 사진 개수 제한
        config.library.minNumberOfItems = 1
        config.library.mediaType = .photo // 미디어타입(사진, 사진/동영상, 동영상)
        config.usesFrontCamera = false
        config.showsPhotoFilters = false
        config.showsVideoTrimmer = false
        config.screens = [.library]
        
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
                    
                    print(type(of: photo.image))
                    print(type(of: self.imageArr))
                    self.imageArr.append(photo.image)
                case .video(let video): // Disable
                    print(video)
                }
            }
                print("imageArr => \(self.imageArr)")
                completion(self.imageArr)
                self.imageArr.removeAll()
                    
                picker.dismiss(animated: true, completion: nil)
         }
          present(picker, animated: true, completion: nil)
    }
    
    func authorization(){
        DispatchQueue.main.async {
            
            // [앨범의 사진에 대한 접근 권한 확인 실시]
            PHPhotoLibrary.requestAuthorization( { status in
                switch status{
                case .authorized:
                    print("")
                    print("====================================")
                    //                print("[\(self.ACTIVITY_NAME) >> testMain() :: 앨범의 사진에 대한 접근 권한 확인 실시]")
                    print("상태 :: 앨범 권한 허용")
                    print("====================================")
                    print("")
                    
                    // [앨범 열기 수행 실시]
//                    self.openPhoto()
                    break
                    
                case .denied:
                    print("")
                    print("====================================")
                    //                print("[\(self.ACTIVITY_NAME) >> testMain() :: 앨범의 사진에 대한 접근 권한 확인 실시]")
                    print("상태 :: 앨범 권한 거부")
                    print("====================================")
                    print("")
                    break
                    
                case .notDetermined:
                    print("")
                    print("====================================")
                    //                print("[\(self.ACTIVITY_NAME) >> testMain() :: 앨범의 사진에 대한 접근 권한 확인 실시]")
                    print("상태 :: 앨범 권한 선택하지 않음")
                    print("====================================")
                    print("")
                    break
                    
                case .restricted:
                    print("")
                    print("====================================")
                    //                print("[\(self.ACTIVITY_NAME) >> testMain() :: 앨범의 사진에 대한 접근 권한 확인 실시]")
                    print("상태 :: 앨범 접근 불가능, 권한 변경이 불가능")
                    print("====================================")
                    print("")
                    break
                    
                default:
                    print("")
                    print("====================================")
                    //                print("[\(self.ACTIVITY_NAME) >> testMain() :: 앨범의 사진에 대한 접근 권한 확인 실시]")
                    print("상태 :: default")
                    print("====================================")
                    print("")
                    break
                }
            })
            
            
        }
    }
}
