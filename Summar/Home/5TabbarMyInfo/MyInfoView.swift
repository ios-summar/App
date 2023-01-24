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

class MyInfoView: UIView{
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
    
    var model : FeedSelectResponse? {
        didSet {
            smLog("\n \(self.model?.content?.count) \n")
            
            tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: tableCellReuseIdentifier)
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.reloadData()
        }
    }
    
    var displayCount : Int = 0
    var pageIndex : Int = 1
    
    var requestDic = Dictionary<String, Any>()
    
//    let UserInfo = UserDefaults.standard.dictionary(forKey: "UserInfo")
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let view1 = UIView()
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
        label.font = FontManager.getFont(Font.Bold.rawValue).laergeFont
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    let major : UILabel = {
        let label = UILabel()
        label.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    let followerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        return view
    }()
    let followerCount : UILabel = {
        let UILabel = UILabel()
        UILabel.font = FontManager.getFont(Font.Bold.rawValue).laergeFont
        UILabel.textAlignment = .center
        UILabel.textColor = .black
        return UILabel
    }()
    let followerLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = FontManager.getFont(Font.Regular.rawValue).medium15Font
        UILabel.text = "팔로워"
        UILabel.textAlignment = .center
        UILabel.textColor = .black
        return UILabel
    }()
    let followingView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        return view
    }()
    let followingCount : UILabel = {
        let UILabel = UILabel()
        UILabel.font = FontManager.getFont(Font.Bold.rawValue).laergeFont
        UILabel.textAlignment = .center
        UILabel.textColor = .black
        return UILabel
    }()
    let followingLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = FontManager.getFont(Font.Regular.rawValue).medium15Font
        UILabel.text = "팔로잉"
        UILabel.textAlignment = .center
        UILabel.textColor = .black
        return UILabel
    }()
    let introductView : UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        view.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        return view
    }()
    let introductLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = FontManager.getFont(Font.Regular.rawValue).medium15Font
        UILabel.textColor = .systemPink
        UILabel.textAlignment = .center
        UILabel.numberOfLines = 0
        return UILabel
    }()
    let view2 : UIView = {
        let view = HomeView()
        return view
    }()
    let view3 = UIView()
    
    let tableView : UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        
        // 테이블뷰 왼쪽 마진 없애기
        view.separatorStyle = .none
//        view.separatorStyle = .singleLine
//        view.cellLayoutMarginsFollowReadableWidth = false
//        view.separatorInset.left = 0
//        view.separatorColor = .gray
        //
        
        view.estimatedRowHeight = 85.0
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView) // 메인뷰에
//        backgroundColor = UIColor.RedSeven
//        scrollView.backgroundColor = UIColor.green
//        view1.backgroundColor = .brown
        _ = [view1, tableView].map { self.scrollView.addSubview($0) }
        _ = [profileview, nickName, major, followerView, followingView, introductView].map { view1.addSubview($0) }
        
        profileview.addSubview(socialBadge)
        profileview.addSubview(profileImg)
        
        self.profileview.bringSubviewToFront(self.socialBadge)
        
        followingView.addSubview(followingCount)
        followingView.addSubview(followingLabel)
        
        followerView.addSubview(followerCount)
        followerView.addSubview(followerLabel)
        
        introductView.addSubview(introductLabel)
        
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview() // 스크롤뷰가 표현될 영역
        }
        
        view1.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-20)
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view1.snp.bottom).offset(10)
//            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(3500)
            make.bottom.equalToSuperview()
        }
        
        profileview.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalToSuperview()
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
            make.right.equalTo(followerView.snp.left)
        }
        
        major.snp.makeConstraints { (make) in
            make.top.equalTo(profileImg.snp.centerY).offset(2)
            make.left.equalTo(profileImg.snp.right).offset(10)
        }
        
        followerView.snp.makeConstraints { (make) in
            make.height.equalTo(profileImg.snp.width)
            make.width.equalTo(60)
            make.right.equalTo(followingView.snp.left).offset(-20)
            make.centerY.equalTo(profileImg.snp.centerY)
        }
        
        followerLabel.snp.makeConstraints { (make) in
            
            make.right.equalTo(followerView.snp.right).offset(-5)
            make.left.equalTo(followerView.snp.left).offset(5)
            make.bottom.equalTo(followerView.snp.bottom).offset(-5)
        }
        
        followerCount.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(followerView.snp.top).offset(5)
        }
        
        followingView.snp.makeConstraints { (make) in
            make.height.equalTo(profileImg.snp.width)
            make.width.equalTo(60)
            make.right.equalToSuperview()
            make.centerY.equalTo(profileImg.snp.centerY)
        }
        
        followingLabel.snp.makeConstraints { (make) in
            
            make.right.equalTo(followingView.snp.right).offset(-5)
            make.left.equalTo(followingView.snp.left).offset(5)
            make.bottom.equalTo(followingView.snp.bottom).offset(-5)
        }
        
        followingCount.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(followingView.snp.top).offset(5)
        }
        
        introductView.snp.makeConstraints{(make) in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(followingView.snp.bottom).offset(30)
            make.height.equalTo(160)
        }
        
        introductLabel.snp.makeConstraints{(make) in
            
            make.top.left.equalTo(20)
            make.bottom.right.equalTo(-20)
        }
        
//        requestMyInfo()
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
                self.followerCount.text = self.viewModel.followerString
                self.followingCount.text = self.viewModel.followingString
                
                if self.viewModel.introduceString == "작성된 자기소개가 없습니다. 😥\n자기소개를 작성해 자신을 소개해보세요." {
                    self.introductLabel.textColor = .systemPink
                }else {
                    self.introductLabel.textColor = .black
                }
                
                self.introductLabel.text = self.viewModel.introduceString
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
    
    func selectFeed() {
        let viewModel = HomeViewModel(0, (pageIndex * 30))
        viewModel.selectFeed()
        viewModel.didFinishFetch = {
            self.model = viewModel.feedSelectResponse
        }
    }
    
    @objc func btnAction(_ sender: Any){
        self.pushDelegate?.pushScreen(UpdateMyInfoViewController.shared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyInfoView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let totalRecordCount = model?.totalRecordCount, let recordsPerPage = model?.recordsPerPage, let currentPageNo = model?.currentPageNo, let totalPageCount = model?.totalPageCount {
            if totalRecordCount < 30 { // 30개 미만일때는 총 건수만 return
                return totalRecordCount
            }else { // 30개 이상일때
                if currentPageNo != totalPageCount { // 총건수를 30으로 나눴을때 현재페이지 != 마지막페이지
                    displayCount = 30 * pageIndex
                    return displayCount // 30개씩 * 현재페이지 ex) 120건 노출시 30.. 60.. 90.. 120...
                }else { // 총건수를 30으로 나눴을때 현재페이지 == 마지막페이지
                    displayCount = (30 * (pageIndex - 1)) + (totalRecordCount % 30)
                    return displayCount //(30개씩 * 현재페이지) + 나머지(총 건수 % 30건)
                }
            }
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! HomeTableViewCell
            if let model = model?.content {
                smLog("\(model.count)")
                setProfileImage(cell.profileImg, model[indexPath.row].user?.profileImageUrl)
                cell.nickName.text = model[indexPath.row].user?.userNickname
                cell.major.text = model[indexPath.row].user?.major2
                cell.contentsLabel.text = model[indexPath.row].contents
                cell.feedImages = model[indexPath.row].feedImages
                
                helper.lineSpacing(cell.contentsLabel, 5)
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("indexPath.row => ", indexPath.row)
        print("displayCount => ", displayCount)
        print("pageIndex => ", pageIndex)
        print("")
        
        if let totalRecordCount = model?.totalRecordCount, let recordsPerPage = model?.recordsPerPage, let currentPageNo = model?.currentPageNo, let totalPageCount = model?.totalPageCount {
            if pageIndex * 30 == indexPath.row + 1 {
                self.pageIndex += 1
                let viewModel = HomeViewModel(0, (pageIndex * 30))
                viewModel.selectFeed()

                viewModel.didFinishFetch = {
                    self.model = viewModel.feedSelectResponse
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = model?.content {
            homeViewDelegate?.pushScreen(FeedDetailViewController.shared, model[indexPath.row - 1])
        }
    }
    
    func setProfileImage(_ imageView: UIImageView,_ urlString: String?) {
        guard let urlString = urlString else {return}
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
    
}
