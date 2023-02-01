//
//  MyInfoView.swift
//  Summar
//
//  Created by mac on 2022/12/14.
// https://hryang.tistory.com/7 => scrollview programmatically

import Foundation
import UIKit

// MARK: - MyInfoView -> MyInfoViewController userInfo 인자전달
protocol MyInfoViewDelegate : AnyObject {
    func parameter(_ userInfo: UserInfo?)
}

protocol PushDelegate : AnyObject {
    func pushScreen(_ VC: UIViewController)
}

class MyInfoView: UIView, ViewAttributes{
    let helper = Helper()
    let request = ServerRequest.shared
    private let tableCellReuseIdentifier = "tableCell"
    private let bannerCellReuseIdentifier = "bannerCell"
    
    weak var delegate : MyInfoViewDelegate?
    weak var pushDelegate : PushDelegate?
    weak var homeViewDelegate : HomeViewDelegate?
    
    // MARK: - Injection
    let viewModel = MyInfoViewModel()
    
    // MARK: - Properties
    private var userInfo: UserInfo? {
        didSet {
            print("MyInfoView userInfo =>\n\(userInfo)")
            self.delegate?.parameter(userInfo)
        }
    }
    
    var displayCount : Int = 0
    var pageIndex : Int = 1
    
    var requestDic = Dictionary<String, Any>()
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray01
        return view
    }()
    lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.contentSize = CGSize(width: self.frame.width, height: 1200)
        return view
    }()
    lazy var followView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Gray01
        view.layer.cornerRadius = 5
        return view
    }()
    let divisionLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Gray02
        return view
    }()
    let followerBtn : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(followBtnAction(_:)), for: .touchUpInside)
        return button
    }()
    let followerCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = FontManager.getFont(Font.Bold.rawValue).mediumFont
        label.text = "0"
        label.sizeToFit()
        return label
    }()
    let followerLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 115, g: 120, b: 127, a: 1)
        label.font = FontManager.getFont(Font.Regular.rawValue).small11Font
        label.text = "팔로워"
        label.sizeToFit()
        return label
    }()
    let followingBtn : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(followBtnAction(_:)), for: .touchUpInside)
        return button
    }()
    let followingCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = FontManager.getFont(Font.Bold.rawValue).mediumFont
        label.text = "0"
        label.sizeToFit()
        return label
    }()
    let followingLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 115, g: 120, b: 127, a: 1)
        label.font = FontManager.getFont(Font.Regular.rawValue).small11Font
        label.text = "팔로잉"
        label.sizeToFit()
        return label
    }()
    let profileImg : UIImageView = {
        let view = UIImageView()
        view.image = nil
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        view.layer.cornerRadius = 21
        view.tintColor = UIColor.grayColor205
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
    let introduceLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
        UILabel.textColor = UIColor.homeContentsColor
        UILabel.textAlignment = .left
        UILabel.numberOfLines = 3
        UILabel.lineBreakMode = .byTruncatingTail
        UILabel.sizeToFit()
        return UILabel
    }()
    
    let profileview = UIView()
    let socialBadge : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    let line2 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Gray02
        return view
    }()
    lazy var btnView = UIView()
    lazy var leftBtn : UIButton = {
        let button = UIButton()
        button.setTitle("내 포트폴리오", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = FontManager.getFont(Font.Bold.rawValue).mediumFont
        button.backgroundColor = .white
        button.tag = 1
        button.addTarget(self, action: #selector(toggleBtn(_:)), for: .touchUpInside)
        return button
    }()
    lazy var indicator : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    lazy var rightBtn : UIButton = {
        let button = UIButton()
        button.setTitle("임시저장", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
        button.backgroundColor = .white
        button.tag = 2
        button.addTarget(self, action: #selector(toggleBtn(_:)), for: .touchUpInside)
        return button
    }()
    lazy var followBtn : UIButton = {
        let button = UIButton()
        button.setTitle("팔로우", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontManager.getFont(Font.Bold.rawValue).smallFont
        button.backgroundColor = UIColor.magnifyingGlassColor
        button.addTarget(self, action: #selector(toggleBtn(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }()
    
//    let tableView : UITableView = {
//        let view = UITableView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .white
//        view.showsVerticalScrollIndicator = false
//        view.isScrollEnabled = false
//
//        // 테이블뷰 왼쪽 마진 없애기
//        view.separatorStyle = .none
//        view.estimatedRowHeight = 85.0
//        view.rowHeight = UITableView.automaticDimension
//        return view
//    }()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setAttributes()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func setUI() {
        backgroundColor = .white
        
        addSubview(line)
        addSubview(scrollView)
        
        scrollView.addSubview(profileview)
        profileview.addSubview(profileImg)
        profileview.addSubview(socialBadge)
        
        scrollView.addSubview(nickName)
        scrollView.addSubview(major)
        scrollView.addSubview(followView)
        
        followView.addSubview(divisionLine)
        followView.addSubview(followerBtn)
        followView.addSubview(followingBtn)
        
        followerBtn.addSubview(followerCountLabel)
        followerBtn.addSubview(followerLabel)
        
        followingBtn.addSubview(followingCountLabel)
        followingBtn.addSubview(followingLabel)
        
        scrollView.addSubview(introduceLabel)
        scrollView.addSubview(line2)
    }
    
    func setAttributes() {
        line.snp.makeConstraints {
            
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(2)
        }
        scrollView.snp.makeConstraints {
            
            $0.top.equalTo(line.snp.bottom)
            $0.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(self.safeAreaLayoutGuide.snp.right)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        profileview.snp.makeConstraints { (make) in
            
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.width.height.equalTo(42)
        }
        socialBadge.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.right.top.equalToSuperview()
        }
        profileImg.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        nickName.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(profileImg.snp.centerY).offset(-1)
            make.left.equalTo(profileImg.snp.right).offset(13)
        }
        major.snp.makeConstraints { (make) in
            
            make.top.equalTo(profileImg.snp.centerY).offset(2)
            make.left.equalTo(profileImg.snp.right).offset(13)
        }
        followView.snp.makeConstraints {
            $0.centerY.equalTo(profileImg.snp.centerY)
            $0.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-20)
            $0.width.equalTo(107)
            $0.height.equalTo(55)
        }
        divisionLine.snp.makeConstraints {
            
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(31)
        }
        followerBtn.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.right.equalTo(divisionLine.snp.left)
        }
        followerCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(followerBtn.snp.centerY).offset(-2)
        }
        followerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(followerBtn.snp.centerY).offset(2)
        }
        followingBtn.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.left.equalTo(divisionLine.snp.right)
        }
        followingCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(followingBtn.snp.centerY).offset(-2)
        }
        followingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(followingBtn.snp.centerY).offset(2)
        }
        introduceLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(profileImg.snp.bottom).offset(22)
            make.left.equalTo(20)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-20)
        }
        line2.snp.makeConstraints { (make) in
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(2)
            make.top.equalTo(introduceLabel.snp.bottom).offset(74)
        }
        
    }

    // MARK: - 내 피드인지, 다른 사용자의 피드인지 확인
    /// 내 피드인지, 다른 사용자의 피드인지 확인
    func infoCheck(_ userInfo : UserInfo?) {
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
            guard let userSeq = value["userSeq"], let userInfo = userInfo else {return}
            
            if userSeq as? Int == userInfo.result.userSeq {
                print("내 피드")
                myFeedSetUp()
            }else {
                print("상대방 피드")
                notMyFeedSetup()
            }
        }
    }
    
    func myFeedSetUp() {
        followBtn.removeFromSuperview()
        
        scrollView.addSubview(btnView)
        btnView.addSubview(leftBtn)
        btnView.addSubview(rightBtn)
        btnView.addSubview(indicator)
        
        btnView.snp.makeConstraints {
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(44)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.centerX.equalToSuperview()
        }
        
        leftBtn.snp.makeConstraints {
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(44)
            $0.right.equalTo(self.btnView.snp.centerX)
            $0.left.equalToSuperview()
        }
        
        rightBtn.snp.makeConstraints {
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(44)
            $0.left.equalTo(self.btnView.snp.centerX)
            $0.right.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(2)
            $0.left.equalToSuperview()
            $0.right.equalTo(self.btnView.snp.centerX)
        }
    }
    
    func notMyFeedSetup() {
        socialBadge.removeFromSuperview()
        btnView.removeFromSuperview()
        scrollView.addSubview(followBtn)
        
        followBtn.snp.makeConstraints {
            $0.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(20)
            $0.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-20)
            $0.bottom.equalTo(line2.snp.top).offset(-20)
            $0.height.equalTo(38)
        }
    }
    
    @objc func followBtnAction(_ sender: Any) {
        
    }
    
    @objc func toggleBtn(_ sender: Any) {
        guard let btn = sender as? UIButton else {return}
        switch btn.tag {
        case 1:
            touchLeft()
        case 2:
            touchRight()
        default:
            print("default")
        }
        
    }
    
    func touchLeft(){
        leftBtn.titleLabel?.font = FontManager.getFont(Font.Bold.rawValue).mediumFont
        rightBtn.titleLabel?.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
        
        indicator.snp.remakeConstraints {
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(2)
            $0.left.equalToSuperview()
            $0.right.equalTo(self.btnView.snp.centerX)
        }
    }
    
    func touchRight(){
        rightBtn.titleLabel?.font = FontManager.getFont(Font.Bold.rawValue).mediumFont
        leftBtn.titleLabel?.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
        
        indicator.snp.remakeConstraints {
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(2)
            $0.right.equalToSuperview()
            $0.left.equalTo(self.btnView.snp.centerX)
        }
    }
    
    
    func requestMyInfo(_ userSeq: Int){
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

            viewModel.getUserInfo(userSeq)
            viewModel.didFinishFetch = {
                self.userInfo = self.viewModel.userInfo
                self.infoCheck(self.userInfo)
                
                self.setProfileImage(self.profileImg, self.viewModel.profileImgURLString)
                self.nickName.text = self.viewModel.nicknameString
                self.major.text = self.viewModel.major2String
                self.followerCountLabel.text = self.viewModel.followerString
                self.followingCountLabel.text = self.viewModel.followingString

                if self.viewModel.introduceString == "작성된 자기소개가 없습니다😥 자기소개를 작성해 자신을 소개해보세요." {
                    self.introduceLabel.textColor = .systemBlue
                }else {
                    self.introduceLabel.textColor = .black
                }

                self.introduceLabel.text = self.viewModel.introduceString
                self.helper.lineSpacing(self.introduceLabel, 10)
            }
        }else {
            print(#file , "\(#function) else")
        }

    }
    
    func setProfileImage(_ imageView: UIImageView,_ urlString: String?) {
        guard let urlString = urlString else {
            imageView.image = UIImage(named: "NonProfile")
            return
        }
        let url = URL(string: urlString)
        //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
        //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(
                  with: url,
                  placeholder: nil,
                  options: [.transition(.fade(1.2))],
                  completionHandler: nil
                )
            }
        }
    }
    
    func requestMyFeed(_ userSeq: Int?){
        guard let userSeq = userSeq else { return }
        smLog("userSeq \(userSeq)")
    }
    
    
    @objc func btnAction(_ sender: Any){
        self.pushDelegate?.pushScreen(UpdateMyInfoViewController.shared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
