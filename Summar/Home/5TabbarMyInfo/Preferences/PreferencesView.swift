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
    
    var userInfo : UserInfo? {
        didSet {
            print("PreferencesView userInfo=>\n \(userInfo)")
            
            nickName.text = userInfo?.result.userNickname
            major.text = userInfo?.result.major2
        }
    }
    
    let cellReuseIdentifier = "PreferencesTableViewCell"
    let preferencesArray = ["프로필 편집", "푸시 알림", "공지사항", "자주 묻는 질문", "버전 정보"]
    
    
    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else {return nil}
        
        return version
    }
    
    let profileView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let profileImg : UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        view.layer.cornerRadius = 27.5
        view.image = UIImage(named: "NonProfile")
        view.tintColor = UIColor.grayColor205
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
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.PreferencesBackgroundColor
        
        _ = [profileView ,tableView].map {
            addSubview($0)
        }
        
        _ = [profileImg, nickName, major, logutBtn].map {
            profileView.addSubview($0)
        }
        
        profileView.snp.makeConstraints{(make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(2)
            make.height.equalTo(82)
        }
        
        profileImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(profileView).offset(20)
            make.width.height.equalTo(55)
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
            make.right.equalTo(profileView.snp.right).offset(-20)
            make.width.equalTo(65)
            make.height.equalTo(30)
        }
        
        
        
        tableView.snp.makeConstraints{(make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(profileView.snp.bottom).offset(16)
        }
        
    }
    
    @objc func logoutAction() {
        if let userInfo = UserDefaults.standard.dictionary(forKey: "UserInfo") {
            guard let socialType = userInfo["socialType"] else{ return }
            print(userInfo)
            let loginType = String(describing: socialType)
            
            UserDefaults.standard.removeObject(forKey: "UserInfo")
            switch loginType {
            case "KAKAO":
                print("KAKAO")
                break
            case "APPLE":
                print("APPLE")
                break
            case "NAVER":
                print("NAVER")
//                self.pushDelegate?.pushScreen(SocialLoginController.shared)
                break
            case "GOOGLE":
                print("GOOGLE")
                break
            default:
                print("default")
            }
           
            let navigationController = UINavigationController(rootViewController: Router())
            navigationController.isNavigationBarHidden = true
            window?.rootViewController = navigationController
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
            self.pushDelegate?.pushScreen(UpdateMyInfoViewController.shared)
            break
        case 1:
            print("1")
//            self.pushDelegate?.pushScreen(<#T##UIViewController#>)
            break
        case 2:
            print("2")
//            self.pushDelegate?.pushScreen(<#T##UIViewController#>)
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
