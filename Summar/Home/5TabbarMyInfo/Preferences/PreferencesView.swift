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

final class PreferencesView: UIView{
    weak var pushDelegate : PushDelegate?
    weak var popDelegate : PopDelegate?
    weak var myInfoDelegate : MyInfoViewDelegate?

    let helper = Helper()
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
        view.layer.cornerRadius = 21
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
        label.font = FontManager.getFont(Font.Bold.rawValue).extraLargeFont
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    let major : UILabel = {
        let label = UILabel()
        label.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        label.textColor = UIColor.init(r: 115, g: 120, b: 127)
        label.sizeToFit()
        return label
    }()
    let logutBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("로그아웃", for: .normal)
        btn.titleLabel?.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
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
    
    let withDrawBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("탈퇴하기", for: .normal)
        btn.setTitleColor(UIColor.fontGrayColor, for: .normal)
        btn.titleLabel?.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        btn.addTarget(self, action: #selector(withDraw), for: .touchUpInside)
        btn.setUnderline()
        return btn
    }()
    
    let withDrawLabel : UILabel = {
        let label = UILabel()
        label.text = "개인정보, SUMMAR에 저장된 콘텐츠와 설정이 모두 삭제됩니다."
        label.textColor = UIColor.fontGrayColor
        label.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.Gray01
        
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
            make.width.height.equalTo(42)
        }
        
        profileImg.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(42)
        }
        
        socialBadge.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.right.top.equalToSuperview()
        }
        
        nickName.snp.makeConstraints { (make) in
            make.bottom.equalTo(profileImg.snp.centerY).offset(-1)
            make.left.equalTo(profileImg.snp.right).offset(13)
        }
        
        major.snp.makeConstraints { (make) in
            make.top.equalTo(profileImg.snp.centerY).offset(2)
            make.left.equalTo(profileImg.snp.right).offset(13)
        }
        
        logutBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImg.snp.centerY)
            make.right.equalTo(view.snp.right).offset(-20)
            make.width.equalTo(65)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints{(make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(16)
            make.height.equalTo(220)
        }
        
        addSubview(withDrawLabel)
        withDrawLabel.snp.makeConstraints{(make) in
            make.left.equalTo(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        addSubview(withDrawBtn)
        withDrawBtn.snp.makeConstraints{(make) in
            make.left.equalTo(20)
            make.bottom.equalTo(withDrawLabel.snp.top).offset(-3)
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
    
    @objc func withDraw() {
        helper.showAlert2(vc: self, message: "지금 탈퇴하면 SUMMAR에 저장된 콘텐츠와 설정이 삭제됩니다. 탈퇴하시겠습니까?", completTitle: "탈퇴") { result in
            if result {
                if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
                    let userSeq = value["userSeq"] as! Int
                    self.viewModel.withDraw(userSeq)
                    
                    self.viewModel.didFinishWithDraw = {
                        self.helper.showAlertActionNormal(vc: self, message: "탈퇴완료", completion: { bool in
                            self.popDelegate?.popScreen()
                        })
                    }
                }else {
                    print("userInfo nil")
                }
            }
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
            cell.updateLabel.alpha = 0.0 //업데이트 필요 1.0  / 필요없음 0.0
            cell.rectangleStroke.alpha = 0.0 // 업데이트 필요 1.0 / 필요없음 0.0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // 프로필 편집
            self.myInfoDelegate?.parameter(userInfo)
            self.pushDelegate?.pushScreen(UpdateMyInfoViewController.shared, nil)
            break
        case 1: // 알림설정
            print("1")
            self.myInfoDelegate?.parameter(userInfo)
            self.pushDelegate?.pushScreen(PushSettingViewController.shared, nil)
            break
        case 2: // 공지사항
            print("2")
            self.pushDelegate?.pushScreen(NoticeController.shared, nil)
            break
        case 3: // 자주 묻는 질문
            print("3")
            self.pushDelegate?.pushScreen(FAQController.shared, nil)
            break
        case 4: // 버전 정보
            print("4")
//            helper.showAlert(vc: self, message: "준비중")
            break
        default:
            print("default")
        }
    }
    
}
