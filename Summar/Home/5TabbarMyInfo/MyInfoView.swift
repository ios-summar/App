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
    static let shared = MyInfoView()
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
    
//    var model : FeedSelectResponse? {
//        didSet {
//            smLog("\n \(self.model?.content?.count) \n")
//
//            tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: tableCellReuseIdentifier)
//
//            tableView.delegate = self
//            tableView.dataSource = self
//
//            tableView.reloadData()
//        }
//    }
    
    var displayCount : Int = 0
    var pageIndex : Int = 1
    
    var requestDic = Dictionary<String, Any>()
    
//    let UserInfo = UserDefaults.standard.dictionary(forKey: "UserInfo")
    
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
        UILabel.layer.borderWidth = 1
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
//    let nickName : UILabel = {
//        let label = UILabel()
//        label.font = FontManager.getFont(Font.Bold.rawValue).extraLargeFont
//        label.textColor = .black
//        label.sizeToFit()
//        return label
//    }()
//    let major : UILabel = {
//        let label = UILabel()
//        label.font = FontManager.getFont(Font.Regular.rawValue).smallFont
//        label.textColor = UIColor(r: 115, g: 120, b: 127)
//        label.sizeToFit()
//        return label
//    }()
//    lazy var followView : UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.Gray01
//        view.layer.cornerRadius = 5
//        return view
//    }()
//    let divisionLine : UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.Gray02
//        return view
//    }()
//    let followerBtn : UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .clear
//        button.addTarget(self, action: #selector(followBtnAction(_:)), for: .touchUpInside)
//        return button
//    }()
//    let followerCountLabel : UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = FontManager.getFont(Font.Bold.rawValue).mediumFont
//        label.text = "0"
//        label.sizeToFit()
//        return label
//    }()
//    let followerLabel : UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.init(r: 115, g: 120, b: 127, a: 1)
//        label.font = FontManager.getFont(Font.Regular.rawValue).small11Font
//        label.text = "팔로워"
//        label.sizeToFit()
//        return label
//    }()
//    let followingBtn : UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .clear
//        button.addTarget(self, action: #selector(followBtnAction(_:)), for: .touchUpInside)
//        return button
//    }()
//    let followingCountLabel : UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = FontManager.getFont(Font.Bold.rawValue).mediumFont
//        label.text = "0"
//        label.sizeToFit()
//        return label
//    }()
//    let followingLabel : UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.init(r: 115, g: 120, b: 127, a: 1)
//        label.font = FontManager.getFont(Font.Regular.rawValue).small11Font
//        label.text = "팔로잉"
//        label.sizeToFit()
//        return label
//    }()
//    let introductLabel : UILabel = {
//        let UILabel = UILabel()
//        UILabel.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
//        UILabel.textColor = .systemPink
//        UILabel.textAlignment = .center
//        UILabel.numberOfLines = 0
//        return UILabel
//    }()
//    let view2 : UIView = {
//        let view = HomeView()
//        return view
//    }()
//    let view3 = UIView()
//
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
    }
    
    @objc func followBtnAction(_ sender: Any) {
        
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
    
    func requestMyFeed(_ userSeq: Int?){
        guard let userSeq = userSeq else { return }
        smLog("userSeq \(userSeq)")
//        viewModel.getUserFeed(userSeq)
    }
    
//    func selectFeed() {
//        let viewModel = HomeViewModel(0, (pageIndex * 30))
//        viewModel.selectFeed()
//        viewModel.didFinishFetch = {
//            self.model = viewModel.feedSelectResponse
//        }
//    }
    
    @objc func btnAction(_ sender: Any){
        self.pushDelegate?.pushScreen(UpdateMyInfoViewController.shared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//extension MyInfoView: UITableViewDelegate, UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let totalRecordCount = model?.totalRecordCount, let recordsPerPage = model?.recordsPerPage, let currentPageNo = model?.currentPageNo, let totalPageCount = model?.totalPageCount {
//            if totalRecordCount < 30 { // 30개 미만일때는 총 건수만 return
//                return totalRecordCount
//            }else { // 30개 이상일때
//                if currentPageNo != totalPageCount { // 총건수를 30으로 나눴을때 현재페이지 != 마지막페이지
//                    displayCount = 30 * pageIndex
//                    return displayCount // 30개씩 * 현재페이지 ex) 120건 노출시 30.. 60.. 90.. 120...
//                }else { // 총건수를 30으로 나눴을때 현재페이지 == 마지막페이지
//                    displayCount = (30 * (pageIndex - 1)) + (totalRecordCount % 30)
//                    return displayCount //(30개씩 * 현재페이지) + 나머지(총 건수 % 30건)
//                }
//            }
//        }else {
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! HomeTableViewCell
//            if let model = model?.content {
//                smLog("\(model.count)")
//                setProfileImage(cell.profileImg, model[indexPath.row].user?.profileImageUrl)
//                cell.nickName.text = model[indexPath.row].user?.userNickname
//                cell.major.text = model[indexPath.row].user?.major2
//                cell.contentsLabel.text = model[indexPath.row].contents
//                cell.feedImages = model[indexPath.row].feedImages
//
//                helper.lineSpacing(cell.contentsLabel, 5)
//            }
//            return cell
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("indexPath.row => ", indexPath.row)
//        print("displayCount => ", displayCount)
//        print("pageIndex => ", pageIndex)
//        print("")
//
//        if let totalRecordCount = model?.totalRecordCount, let recordsPerPage = model?.recordsPerPage, let currentPageNo = model?.currentPageNo, let totalPageCount = model?.totalPageCount {
//            if pageIndex * 30 == indexPath.row + 1 {
//                self.pageIndex += 1
//                let viewModel = HomeViewModel(0, (pageIndex * 30))
//                viewModel.selectFeed()
//
//                viewModel.didFinishFetch = {
//                    self.model = viewModel.feedSelectResponse
//                    self.tableView.reloadData()
//                }
//
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let model = model?.content {
//            homeViewDelegate?.pushScreen(FeedDetailViewController.shared, model[indexPath.row - 1])
//        }
//    }
//
//    func setProfileImage(_ imageView: UIImageView,_ urlString: String?) {
//        guard let urlString = urlString else {return}
//        let url = URL(string: urlString)
//        //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
//        //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
//        DispatchQueue.global().async {
//            DispatchQueue.main.async {
//                imageView.kf.indicatorType = .activity
//                imageView.kf.setImage(
//                  with: url,
//                  placeholder: nil,
//                  options: [.transition(.fade(1.2))],
//                  completionHandler: nil
//                )
//            }
//        }
//    }
//
//}
