//
//  PreferencesView.swift
//  Summar
//
//  Created by mac on 2023/01/04.
//

import Foundation
import UIKit

protocol PopDelegate : AnyObject {
    func popScreen()
}

class PreferencesView: UIView{
    weak var pushDelegate : PushDelegate?
    weak var popDelegate : PopDelegate?
    weak var myInfoDelegate : MyInfoViewDelegate?
    
    let viewModel = PreferencesViewModel()
    
    var userInfo : UserInfo? {
        didSet {
            print("PreferencesView userInfo=>\n \(userInfo)")
            
            if let profile = userInfo?.result.profileImageUrl {
                //url에 정확한 이미지 url 주소를 넣는다.
                let url = URL(string: profile)
                //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
                //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
    //                    cell.imageView.image = UIImage(data: data!)
                        self.profileImg.kf.indicatorType = .activity
                        self.profileImg.kf.setImage(
                          with: url,
                          placeholder: nil,
                          options: [.transition(.fade(1.2))],
                          completionHandler: nil
                        )
                    }
                }
            }else {
                profileImg.image = UIImage(named: "NonProfile")
            }
            
            nickName.text = userInfo?.result.userNickname
            major.text = userInfo?.result.major2
        }
    }
    
    let cellReuseIdentifier = "PreferencesTableViewCell"
    
    var preferencesArray : [String] = []
    var preferencesImgArray : [UIImage] = []
    
    
    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else {return nil}
        
        return version
    }
    
    let view : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let profileview = UIView()
    let profileImg : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 27.5
//        view.image = UIImage(named: "NonProfile")
        view.tintColor = UIColor.grayColor205
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    let socialBadge : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    let nickName : UILabel = {
        let label = UILabel()
        label.text = "이희주"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    let major : UILabel = {
        let label = UILabel()
        label.text = "컴퓨터정보공학과"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    let logutBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("로그아웃", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.Gray02
        btn.setTitleColor(UIColor.init(r: 70, g: 76, b: 83), for: .normal)
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        return btn
    }()
    let followerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        return view
    }()
    
    lazy var tableView : UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(PreferencesTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.PreferencesBackgroundColor
        
        arrayInit() //설정 배열 Init
        
        _ = [view ,tableView].map {
            addSubview($0)
        }
        
        _ = [profileview, nickName, major, logutBtn].map {
            view.addSubview($0)
        }
        
        _ = [profileImg, socialBadge].map {
            profileview.addSubview($0)
        }
        
        view.snp.makeConstraints{(make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(2)
            make.height.equalTo(82)
        }
        
        profileview.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.width.height.equalTo(55)
        }
        
        profileImg.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(55)
        }
        
        socialBadge.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.right.top.equalToSuperview()
        }
        
        nickName.snp.makeConstraints { (make) in
            make.bottom.equalTo(profileImg.snp.centerY).offset(-1)
            make.left.equalTo(profileImg.snp.right).offset(10)
        }
        
        major.snp.makeConstraints { (make) in
            make.top.equalTo(profileImg.snp.centerY).offset(2)
            make.left.equalTo(profileImg.snp.right).offset(10)
        }
        
        logutBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImg.snp.centerY)
            make.right.equalTo(view.snp.right).offset(-20)
            make.width.equalTo(65)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints{(make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(16)
        }
        
        requestMyInfo()
    }
    
    func requestMyInfo(){
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo") {
            let socialType = value["socialType"] as? String
            print("socialType", socialType)
            
            switch socialType {
            case "KAKAO":
                socialBadge.image = UIImage(named: "kakao")
            case "APPLE":
                socialBadge.image = UIImage(named: "apple")
            case "NAVER":
                socialBadge.image = UIImage(named: "naver")
            case "GOOGLE":
                socialBadge.image = UIImage(named: "google")
            default:
                print("default")
            }
            
            viewModel.getUserInfo()
            
            viewModel.didFinishFetch = {
                self.userInfo = self.viewModel.userInfo
                if let profile = self.userInfo?.result.profileImageUrl {
//                if let profile = self.viewModel.profileImgURLString {
                    //url에 정확한 이미지 url 주소를 넣는다.
                    let url = URL(string: profile)
                    //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
                    //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        DispatchQueue.main.async {
        //                    cell.imageView.image = UIImage(data: data!)
                            self.profileImg.kf.indicatorType = .activity
                            self.profileImg.kf.setImage(
                              with: url,
                              placeholder: nil,
                              options: [.transition(.fade(1.2))],
                              completionHandler: nil
                            )
                        }
                    }
                }else {
                    self.profileImg.image = UIImage(named: "NonProfile")
                }
                
                self.nickName.text = self.viewModel.nicknameString
                self.major.text = self.viewModel.major2String
            }
        }else {
            print(#file , "\(#function) else")
        }
        
    }
    
    func arrayInit(){
        _ = ["프로필 편집", "알림설정", "공지사항", "자주 묻는 질문", "버전 정보"].map {
            preferencesArray.append($0)
        }
        
        _ = ["solid", "alarm", "notice", "FAQ", "info"].map {
            preferencesImgArray.append(UIImage(named: $0)!)
        }
    }
    
    @objc func logoutAction() {
        if let userInfo = UserDefaults.standard.dictionary(forKey: "UserInfo") {
            guard let socialType = userInfo["socialType"] else{ return }
//            print(userInfo)
            let loginType = String(describing: socialType)
            
            _ = ["UserInfo", "accessToken", "refreshToken"].map {
                UserDefaults.standard.removeObject(forKey: $0)
            }
            
            switch loginType {
            case "KAKAO":
                print("KAKAO")
                break
            case "APPLE":
                print("APPLE")
                break
            case "NAVER":
                print("NAVER")
                break
            case "GOOGLE":
                print("GOOGLE")
                break
            default:
                print("default")
            }

            
            self.popDelegate?.popScreen()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PreferencesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preferencesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PreferencesTableViewCell
        cell.preferencesImg.image = preferencesImgArray[indexPath.row]
        cell.label.text = preferencesArray[indexPath.row]
        
        // 버전정보
        if indexPath.row == 4 {
            cell.versionLabel.text = version
//            cell.rectangleStroke.alpha = 0.0
            //버전 체크후
            cell.updateLabel.alpha = 1.0 //업데이트 필요 1.0  / 필요없음 0.0
            cell.rectangleStroke.alpha = 1.0 // 업데이트 필요 1.0 / 필요없음 0.0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.myInfoDelegate?.parameter(userInfo)
            self.pushDelegate?.pushScreen(UpdateMyInfoViewController.shared)
            break
        case 1:
            print("1")
            self.myInfoDelegate?.parameter(userInfo)
            self.pushDelegate?.pushScreen(PushSettingViewController.shared)
            break
        case 2:
            print("2")
            self.pushDelegate?.pushScreen(NoticeController.shared)
            break
        case 3:
            print("3")
//            self.pushDelegate?.pushScreen(<#T##UIViewController#>)
            break
        case 4:
            print("4")
//            self.pushDelegate?.pushScreen(<#T##UIViewController#>)
            break
        default:
            print("default")
        }
    }
    
}
