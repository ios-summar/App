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
    func pushScreen(_ VC: UIViewController, _ any: Any?)
}

final class MyInfoView: UIView, ViewAttributes, PushDelegate{
    func pushScreen(_ VC: UIViewController, _ any: Any?) {
        if VC.isKind(of: FeedDetailViewController.self){
            let VC = FeedDetailViewController()
            self.pushDelegate?.pushScreen(VC, any)
        }else if VC.isKind(of: WriteFeedController.self){
            let VC = WriteFeedController()
            self.pushDelegate?.pushScreen(VC, any)
        }
    }
    
    let helper = Helper.shared
    let fontManager = FontManager.shared
    let request = ServerRequest.shared
    
    weak var delegate : MyInfoViewDelegate?
    weak var pushDelegate : PushDelegate?
    weak var homeViewDelegate : HomeViewDelegate?
    
    // MARK: - Injection
    let viewModel = MyInfoViewModel(nil, nil)
    
    // MARK: - Properties
    private var userInfo: UserInfo? {
        didSet {
            print("MyInfoView userInfo =>\n\(userInfo)")
            self.delegate?.parameter(userInfo)
        }
    }
    var followCheck: Bool? {
        didSet {
            print("followCheck \(followCheck)")
        }
    }
    var portfolioResponse: FeedSelectResponse? {
        didSet {
            portfolioTableView.delegate = self
            portfolioTableView.dataSource = self
            portfolioTableView.reloadData()
        }
    }
    
    var temporaryResponse: FeedSelectResponse? {
        didSet {
            temporarySaveCollectionView.reloadData()
            
            if temporaryResponse?.content?.count != 0 {
                temporarySaveCollectionView.alpha = 1.0
                
                scrollView.addSubview(temporarySaveCollectionView)
                temporarySaveCollectionView.snp.makeConstraints {
                    $0.top.equalTo(line2.snp.bottom)
                    $0.left.right.equalTo(self.safeAreaLayoutGuide)
                }
            }else {
                portfolioTableView.alpha = 0.0
                temporarySaveCollectionView.alpha = 0.0
                notExist.alpha = 1.0
                notExistLabel.alpha = 1.0
                notExistLabel.text = "임시 저장된 포트폴리오가 없습니다."
            }
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
//        view.contentSize = CGSize(width: self.frame.width, height: 1200)
        view.backgroundColor = UIColor.Gray01
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
        button.tag = 11
        return button
    }()
    lazy var followerCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = self.fontManager.getFont(Font.Bold.rawValue).mediumFont
        label.sizeToFit()
        return label
    }()
    lazy var followerLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 115, g: 120, b: 127, a: 1)
        label.font = self.fontManager.getFont(Font.Regular.rawValue).small11Font
        label.text = "팔로워"
        label.sizeToFit()
        return label
    }()
    let followingBtn : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(followBtnAction(_:)), for: .touchUpInside)
        button.tag = 12
        return button
    }()
    lazy var followingCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = self.fontManager.getFont(Font.Bold.rawValue).mediumFont
        label.sizeToFit()
        return label
    }()
    lazy var followingLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 115, g: 120, b: 127, a: 1)
        label.font = self.fontManager.getFont(Font.Regular.rawValue).small11Font
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
    lazy var nickName : UILabel = {
        let label = UILabel()
        label.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    lazy var major : UILabel = {
        let label = UILabel()
        label.font = self.fontManager.getFont(Font.Regular.rawValue).smallFont
        label.textColor = UIColor.init(r: 115, g: 120, b: 127)
        label.sizeToFit()
        return label
    }()
    lazy var introduceLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = self.fontManager.getFont(Font.Regular.rawValue).mediumFont
        UILabel.textColor = UIColor.homeContentsColor
        UILabel.textAlignment = .left
        UILabel.numberOfLines = 3
        UILabel.lineBreakMode = .byTruncatingTail
        UILabel.sizeToFit()
        return UILabel
    }()
    lazy var profileSuperview: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        return view
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
        button.titleLabel?.font = self.fontManager.getFont(Font.Bold.rawValue).mediumFont
        button.backgroundColor = .white
        button.tag = 1
        button.addTarget(self, action: #selector(profileBtnAction(_:)), for: .touchUpInside)
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
        button.titleLabel?.font = self.fontManager.getFont(Font.Regular.rawValue).mediumFont
        button.backgroundColor = .white
        button.tag = 2
        button.addTarget(self, action: #selector(profileBtnAction(_:)), for: .touchUpInside)
        return button
    }()
    lazy var followBtn : UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = self.fontManager.getFont(Font.Bold.rawValue).smallFont
        button.tag = 3
        button.addTarget(self, action: #selector(profileBtnAction(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var portfolioTableView : UITableView = {
        let view = ContentSizedTableView()
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        
        // 테이블뷰 왼쪽 마진 없애기
        view.separatorStyle = .none
        view.estimatedRowHeight = UITableView.automaticDimension
        view.rowHeight = UITableView.automaticDimension
        view.register(PortFolioTableViewCell.self, forCellReuseIdentifier: "PortFolioTableViewCell")
        return view
    }()
    lazy var notExist : UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.0
        imageView.image = UIImage(named: "NoCount")
        imageView.tintColor = UIColor.imageViewColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var notExistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = self.fontManager.getFont(Font.SemiBold.rawValue).mediumFont
        label.sizeToFit()
        return label
    }()
    lazy var temporarySaveCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 12, right: 20)
        
        let view = ContentSizedCollectionView(frame: .zero, collectionViewLayout: layout)
        view.alpha = 0.0
        view.backgroundColor = UIColor.Gray01 //.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        
        view.register(TemporarySaveCollectionvViewCell.self, forCellWithReuseIdentifier: "TemporarySaveCollectionvViewCell")
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAttributes()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        scrollView.updateContentSize()
    }
    
    func setUI() {
        backgroundColor = .white
        
        addSubview(line)
        addSubview(scrollView)
        scrollView.addSubview(profileSuperview)
        
        profileSuperview.addSubview(profileview)
        profileview.addSubview(profileImg)
        profileview.addSubview(socialBadge)
        
        profileSuperview.addSubview(nickName)
        profileSuperview.addSubview(major)
        
        profileSuperview.addSubview(followView)
        followView.addSubview(divisionLine)
        followView.addSubview(followerBtn)
        
        followView.addSubview(followingBtn)
        followerBtn.addSubview(followerCountLabel)
        followerBtn.addSubview(followerLabel)
        
        followingBtn.addSubview(followingCountLabel)
        followingBtn.addSubview(followingLabel)
        
        profileSuperview.addSubview(introduceLabel)
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
        profileSuperview.snp.makeConstraints {
            
            $0.top.equalTo(0)
            $0.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(self.safeAreaLayoutGuide.snp.right)
            $0.height.equalTo(230)
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
            make.top.equalTo(profileSuperview.snp.bottom)
        }
        
    }
    
    // MARK: - 내 피드인지, 다른 사용자의 피드인지 확인
    /// 내 피드인지, 다른 사용자의 피드인지 확인
    func infoCheck(_ userInfo : UserInfo?) {
        guard let opponentUserSeq = userInfo?.result.userSeq else {return}
        getPortfolio()
        
        if getMyUserSeq() == opponentUserSeq {
            print("내 피드")
            myFeedSetUp()
        }else {
            print("상대방 피드")
            notMyFeedSetup(opponentUserSeq, getMyUserSeq())
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
    
    func notMyFeedSetup(_ followedUserSeq: Int, _ followingUserSeq: Int) {
        viewModel.followCheck(followedUserSeq, followingUserSeq)
        viewModel.didFinishFollowCheckFetch = {
            guard let followResult = self.viewModel.followResult else { return }
            
            if !followResult { // 팔로우 안한 상태
                self.followBtn.setTitle("팔로우", for: .normal)
                self.followBtn.backgroundColor = UIColor.magnifyingGlassColor
            }else { // 팔로우 한 상태
                self.followBtn.setTitle("팔로우 취소", for: .normal)
                self.followBtn.backgroundColor = UIColor.init(r: 70, g: 76, b: 83)
            }
        }
        
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
    
    /// 팔로워, 팔로잉 리스트 화면이동 버튼 action
    @objc func followBtnAction(_ sender: Any) {
        guard let userSeq = userInfo?.result.userSeq, let btn = sender as? UIButton else {return} // 내 피드 혹은 상대 피드
        let VC = FollowListTabman()
        var param : Dictionary<String, Int> = ["userSeq": userSeq]
        
        switch btn.tag {
        case 11:
            param["scrollToIndex"] = 0
        case 12:
            param["scrollToIndex"] = 1
        default:
            break
        }
        
        self.pushDelegate?.pushScreen(VC, param)
    }
    
    @objc func profileBtnAction(_ sender: Any) {
        guard let btn = sender as? UIButton else {return}
        
        switch btn.tag {
        case 1:
            touchLeft() // 내 포트폴리오
        case 2:
            touchRight() // 임시저장
        case 3: // 팔로워
            followAction()
        default:
            print("default")
        }
        
    }
    
    func touchLeft(){
        getPortfolio()
        
        leftBtn.titleLabel?.font = self.fontManager.getFont(Font.Bold.rawValue).mediumFont
        rightBtn.titleLabel?.font = self.fontManager.getFont(Font.Regular.rawValue).mediumFont
        
        indicator.snp.remakeConstraints {
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(2)
            $0.left.equalToSuperview()
            $0.right.equalTo(self.btnView.snp.centerX)
        }
    }
    
    func touchRight(){
        portfolioTableView.alpha = 0.0
        
        getTemporarySave()
        
        rightBtn.titleLabel?.font = self.fontManager.getFont(Font.Bold.rawValue).mediumFont
        leftBtn.titleLabel?.font = self.fontManager.getFont(Font.Regular.rawValue).mediumFont
        
        indicator.snp.remakeConstraints {
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(2)
            $0.right.equalToSuperview()
            $0.left.equalTo(self.btnView.snp.centerX)
        }
    }
    
    func followAction(){
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
            guard let userSeq = value["userSeq"], let userInfo = userInfo, let opponentUserSeq = userInfo.result.userSeq else {return}
            let myUserSeq: Int = userSeq as! Int
            let param : Dictionary<String, Int> = ["followedUserSeq": opponentUserSeq, "followingUserSeq": myUserSeq]
            
            UIDevice.vibrate()
            
            LoadingIndicator.showLoading()
            
            guard let text = followBtn.titleLabel?.text else {return}
            switch text { // 버튼 타이틀로 분기 처리
            case "팔로우":
                viewModel.followAction(param, "POST")
                viewModel.didFinishFollowFetch = {
                    self.followBtn.setTitle("팔로우 취소", for: .normal)
                    self.followBtn.backgroundColor = UIColor.init(r: 70, g: 76, b: 83)
                    
                    self.requestMyInfo(opponentUserSeq)
                    
                    UIView.animate(withDuration: 1.5, animations: {
                        LoadingIndicator.hideLoading()
                    })
                }
            case "팔로우 취소":
                viewModel.followAction(param, "DELETE")
                viewModel.didFinishFollowFetch = {
                    self.followBtn.setTitle("팔로우", for: .normal)
                    self.followBtn.backgroundColor = UIColor.magnifyingGlassColor
                    
                    self.requestMyInfo(opponentUserSeq)
                    
                    UIView.animate(withDuration: 1.5, animations: {
                        LoadingIndicator.hideLoading()
                    })
                }
            default:
                print("default")
            }
            
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
                
                if self.viewModel.introduceString == "작성된 자기소개가 없습니다." {
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
    
    func getPortfolio(){
        guard let userSeq = userInfo?.result.userSeq else {return}
        viewModel.getPortfolio(userSeq)
        
        viewModel.didFinishPortfolioFetch = {
            self.portfolioResponse = self.viewModel.feedSelectResponse
            self.setPortfolio(self.portfolioResponse)
        }
    }
    
    func getTemporarySave(){
        let viewModel = MyInfoViewModel(0, 100000)
        viewModel.getTemporarySave()
        
        viewModel.didFinishTemporarySaveFetch = {
            self.temporaryResponse = viewModel.temporaryResponse
        }
    }
    
    func setPortfolio(_ feed: FeedSelectResponse?) {
        smLog("")
        guard let feed = feed else {return}
        if feed.totalRecordCount != 0 {
            smLog("")
            portfolioTableView.alpha = 1.0
            temporarySaveCollectionView.alpha = 0.0
            notExistLabel.alpha = 1.0
            notExist.alpha = 0.0
            
            scrollView.addSubview(portfolioTableView)
            portfolioTableView.snp.makeConstraints {
                $0.top.equalTo(line2.snp.bottom)
                $0.left.right.equalTo(self.safeAreaLayoutGuide)
            }
        }else {
            smLog("")
            portfolioTableView.alpha = 0.0
            temporarySaveCollectionView.alpha = 0.0
            notExist.alpha = 1.0
            notExistLabel.alpha = 1.0
            
            scrollView.addSubview(notExist)
            scrollView.addSubview(notExistLabel)
            
            notExistLabel.text = "작성한 포트폴리오가 없습니다."
            
            notExist.snp.makeConstraints {
                
                $0.top.equalTo(line2.snp.bottom).offset(80)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(162)
                $0.height.equalTo(194)
            }
            notExistLabel.snp.makeConstraints {
                
                $0.top.equalTo(notExist.snp.bottom).offset(2)
                $0.centerX.equalToSuperview()
            }
            self.setNeedsDisplay()
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
                    completionHandler: { result in
                    switch(result) {
                        case .success(let imageResult):
                        let resized = resize(image: imageResult.image, newWidth: 40)
                        imageView.image = resized
                        imageView.isHidden = false
                        case .failure(let error):
                            imageView.isHidden = true
                        }
                    })
            }
        }
    }
    
    func requestMyFeed(_ userSeq: Int?){
        guard let userSeq = userSeq else { return }
        smLog("userSeq \(userSeq)")
    }
    
    
    @objc func btnAction(_ sender: Any){
        self.pushDelegate?.pushScreen(UpdateMyInfoViewController(), nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyInfoView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.setNeedsDisplay()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feed = portfolioResponse?.totalRecordCount else {return 0}
        return feed
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortFolioTableViewCell", for: indexPath) as! PortFolioTableViewCell
        guard let feed = portfolioResponse?.content?[indexPath.row] else {return UITableViewCell()}
        cell.delegate = self
        cell.setUpCell(feed)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let feed = portfolioResponse?.content?[indexPath.row] else {return}
        self.pushDelegate?.pushScreen(FeedDetailViewController(), feed)
    }
}

extension MyInfoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.setNeedsDisplay()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2 - 30, height: (UIScreen.main.bounds.width/2 - 30) * 1.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let totalRecordCount = temporaryResponse?.totalRecordCount else {return 0}
        smLog("\(totalRecordCount)")
        return totalRecordCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemporarySaveCollectionvViewCell", for: indexPath) as! TemporarySaveCollectionvViewCell
        guard let content = temporaryResponse?.content?[indexPath.row] else {return UICollectionViewCell()}
        cell.setUpCell(content)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        smLog("\(indexPath.row)")
    }
    
}
