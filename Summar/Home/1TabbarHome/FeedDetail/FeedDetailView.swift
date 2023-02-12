//
//  FeedDetailView.swift
//  Summar
//
//  Created by ukBook on 2023/01/22.
//

import Foundation
import UIKit

final class FeedDetailView: UIView, ViewAttributes, UIScrollViewDelegate, UITextViewDelegate, PushDelegate, TableViewReload {
    func pushScreen(_ VC: UIViewController, _ any: Any?) {
        if VC.isKind(of: ProfileViewController.self) {
            let VC = ProfileViewController()
            let userSeq = any as! Int
            
            self.delegate?.pushScreen(VC, userSeq)
        }else if VC.isKind(of: ReportViewController.self) {
            let VC = ReportViewController()
            let param = any as! Dictionary<String, Any>
            
            self.delegate?.pushScreen(VC, param)
        }
    }
    
    func tableViewReload() {
        self.commentTableView.reloadData()
        
        guard let feedInfo = feedInfo else { return }
        setUpContent(feedInfo)
    }
    
    weak var delegate: PushDelegate?
    let viewModel = FeedDetailViewModel()
    let homeViewModel = HomeViewModel(nil, nil)
    let helper = Helper.shared
    
    var likeCountInt: Int = 0
    var commentCountInt: Int = 0
    var parentCommentSeq: Int = 0
    let imageViewWidth : CGFloat = {
        let width = UIScreen.main.bounds.width
        return width - 40
    }()
    var imageArr = [String]()
    var feedInfo : FeedInfo? {
        didSet {
            guard let commentYn = feedInfo?.commentYn else {return}
            
            _ = [bubbleImage, commentCount].map {
                $0.alpha = commentYn ? 1.0 : 0.0
            }
            
            // 댓글 활성화 => addSubView
            self.setCommentTableView(commentYn)
            commentYn ? self.getFeedComment() : nil
        }
    }
    var feedComment: FeedComment?
    
    var size: Int = 100000
    var totalCount: Int = 0
    
    let textViewPlaceHolder = "댓글을 입력해 주세요."
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray01
        return view
    }()
    lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
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
    lazy var profileImg : UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        view.layer.cornerRadius = 20
        view.image = UIImage(named: "NonProfile")
        view.tintColor = UIColor.grayColor205
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.tag = 1
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelect(_:))
        )
        view.addGestureRecognizer(recognizer)
        
        return view
    }()
    lazy var nickName : UILabel = {
        let label = UILabel()
        label.font = FontManager.getFont(Font.Bold.rawValue).medium15Font
        label.textColor = .black
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.tag = 1
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelect(_:))
        )
        label.addGestureRecognizer(recognizer)
        
        return label
    }()
    lazy var major : UILabel = {
        let label = UILabel()
        label.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        label.textColor = UIColor.init(r: 115, g: 120, b: 127)
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.tag = 1
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelect(_:))
        )
        label.addGestureRecognizer(recognizer)
        
        return label
    }()
    let contentsLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
        UILabel.textColor = UIColor.homeContentsColor
        UILabel.textAlignment = .left
        UILabel.numberOfLines = 0
        UILabel.lineBreakMode = .byTruncatingTail
        UILabel.sizeToFit()
        return UILabel
    }()
    lazy var pageControl: UIPageControl = {
        // Create a UIPageControl.
        let pageControl = UIPageControl()
        // Set the number of pages to page control.
        //        pageControl.numberOfPages = self.arrProductPhotos.count
        
        // Set the current page.
        pageControl.currentPage = 0
        
        // 페이지 표시 색상을 밝은 회색 설정
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        // 현재 페이지 표시 색상을 검정색으로 설정
        pageControl.currentPageIndicatorTintColor = UIColor.white
        
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    lazy var view = UIView()
    lazy var scrollViewHorizontal: UIScrollView = {
        // Create a UIScrollView.
        let scrollView = UIScrollView()
        // Hide the vertical and horizontal indicators.
        
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false
        
        // Allow paging.
        scrollView.isPagingEnabled = true
        
        // Set delegate of ScrollView.
        scrollView.delegate = self
        
        scrollView.isScrollEnabled = true
        
        scrollView.layer.cornerRadius = 6
        scrollView.backgroundColor = .clear
        
        // Specify the screen size of the scroll.
        //        scrollView.contentSize = CGSize(width: CGFloat(pageSize) * self.view.frame.maxX, height: 0)
        
        return scrollView
    }()
    
    lazy var heartImage : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart") // 꽉찬 하트 heart.fill
        view.tintColor = .black
        view.isUserInteractionEnabled = true
        view.tag = 2
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelect(_:))
        )
        view.addGestureRecognizer(recognizer)
        
        return view
    }()
    lazy var likeCount : UILabel = {
        let label = UILabel()
        label.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.tag = 2
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelect(_:))
        )
        label.addGestureRecognizer(recognizer)
        
        return label
    }()
    lazy var bubbleImage : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "bubble.left")
        view.tintColor = .black
        return view
    }()
    lazy var commentCount : UILabel = {
        let label = UILabel()
        label.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        return label
    }()
    lazy var bookmark : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "bookmark") // 꽉찬 북마크 heart.fill
        view.tintColor = .black
        view.isUserInteractionEnabled = true
        view.tag = 3
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelect(_:))
        )
        view.addGestureRecognizer(recognizer)
        return view
    }()
    lazy var commentTableView: UITableView = {
        let view = ContentSizedTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        
        // 테이블뷰 왼쪽 마진 없애기
        view.separatorStyle = .none
        view.estimatedRowHeight = 60
        view.rowHeight = UITableView.automaticDimension
        view.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        return view
    }()
    let line2 : UIView = {
        let view = UIView()
        view.backgroundColor = .Gray01
        return view
    }()
    lazy var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.Gray02
        textView.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
        textView.text = textViewPlaceHolder
        textView.layer.cornerRadius = 18
        textView.textColor = .lightGray
        textView.delegate = self
//        textView.sizeToFit()
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 15, bottom: 5, right: 30)
        return textView
    }()
    lazy var uploadImg: UIImageView = {
        let view = UIImageView()
        view.alpha = 0.0
        view.image = UIImage(named: "upload")
        view.isUserInteractionEnabled = true
        view.tag = 4
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelect(_:))
        )
        view.addGestureRecognizer(recognizer)
        
        return view
    }()
    
    func setUpContent(_ feedInfo: FeedInfo) {
        guard let feedSeq = feedInfo.feedSeq else { return }
        smLog("\n \(feedInfo)")
        // 피드 프로필 Set
        viewModel.getFeedInfo(feedSeq)
        viewModel.didFinishFetch = {
            self.feedInfo = self.viewModel.feedInfo
            guard let likeYn = self.feedInfo?.likeYn, let commentYn = self.feedInfo?.commentYn, let totalLikeCount = self.feedInfo?.totalLikeCount, let totalCommentCount = self.feedInfo?.totalCommentCount, let scrapYn = self.feedInfo?.scrapYn else {return}
            
//            guard let commentYn = self.viewModel.commentYn else {return}
//            let alphaCGFloat = commentYn ? 1.0 : 0.0
//
//            // 댓글 막아놓음
//            self.bubbleImage.alpha = alphaCGFloat
//            self.commentCount.alpha = alphaCGFloat
//
//            // 댓글 활성화 => addSubView
//            self.setCommentTableView(commentYn)
            
            // 프로필
            self.setProfileImage(self.profileImg, self.viewModel.profileImgURLString) // 프로필 사진
            self.nickName.text = self.viewModel.nicknameString // 닉네임
            self.major.text = self.viewModel.major2String // 전공
            self.followerCountLabel.text = self.viewModel.followerString //팔로우
            self.followingCountLabel.text = self.viewModel.followingString //팔로잉
            
            // 피드 내용
            self.contentsLabel.text = self.viewModel.contentString
            self.helper.lineSpacing(self.contentsLabel, 5)
            
            // 피드 이미지
            guard let image = self.viewModel.feedInfo?.feedImages else {return}
            
            for i in 0 ..< image.count {
                self.imageArr.append(image[i].imageUrl!)
            }
            
            self.initImageArr(self.imageArr) { finish in
                if finish {
                    self.imageArr = []
                }
            }
            // 좋아요
            guard let image = likeYn ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart") else {return}
            self.heartImage.image = image
            
            // 좋아요 카운트
            self.likeCountInt = totalLikeCount
            self.likeCount.text = String(self.likeCountInt.commaRepresentation)
            
            if commentYn {
                // 댓글 카운트
                self.commentCountInt = totalCommentCount
                
                self.commentCount.text = String(self.commentCountInt.commaRepresentation)
                self.bubbleImage.alpha = 1.0
                self.commentCount.alpha = 1.0
            }else {
                self.bubbleImage.alpha = 0.0
                self.commentCount.alpha = 0.0
            }
            
            // 북마크
            guard let image = scrapYn ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark") else {return}
            
            self.bookmark.image = image
            if scrapYn {
                self.bookmark.tintColor = UIColor.magnifyingGlassColor
            }else {
                self.bookmark.tintColor = .black
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        smLog("")
        scrollView.updateContentSize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setAttributes()
    }
    
    func setUI() {
        backgroundColor = .white
        
        addSubview(commentView)
        addSubview(line)
        addSubview(scrollView)
        
        scrollView.addSubview(profileImg)
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
        
        scrollView.addSubview(contentsLabel)
        scrollView.addSubview(view)
        
        view.addSubview(scrollViewHorizontal)
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
        
        scrollView.addSubview(heartImage)
        scrollView.addSubview(likeCount)
        
        scrollView.addSubview(bubbleImage)
        scrollView.addSubview(commentCount)
        scrollView.addSubview(bookmark)
        
        scrollView.addSubview(line2)
    }
    
    func setAttributes() {
        line.snp.makeConstraints {
            
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(2)
        }
        scrollView.snp.makeConstraints {
            
            $0.top.equalTo(line.snp.bottom)
            $0.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        profileImg.snp.makeConstraints { (make) in
            
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.width.height.equalTo(40)
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
        contentsLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(profileImg.snp.bottom).offset(22)
            make.left.equalTo(20)
            make.width.equalTo(imageViewWidth)
        }
        view.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(contentsLabel.snp.bottom).offset(16)
            make.width.equalTo(imageViewWidth)
            make.height.equalTo(imageViewWidth)
        }
        scrollViewHorizontal.snp.makeConstraints { (make) in
            
            make.edges.equalToSuperview()
        }
        pageControl.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(view.snp.bottom).offset(-10)
            make.width.equalTo(imageViewWidth)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
        }
        heartImage.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom).offset(20)
            $0.left.equalTo(20)
            $0.width.height.equalTo(20)
        }
        likeCount.snp.makeConstraints {
            $0.centerY.equalTo(heartImage.snp.centerY)
            $0.left.equalTo(heartImage.snp.right).offset(5)
        }
        bubbleImage.snp.makeConstraints {
            $0.centerY.equalTo(heartImage.snp.centerY)
            $0.left.equalTo(likeCount.snp.right).offset(20)
            $0.width.height.equalTo(20)
        }
        commentCount.snp.makeConstraints {
            $0.centerY.equalTo(bubbleImage.snp.centerY)
            $0.left.equalTo(bubbleImage.snp.right).offset(5)
        }
        bookmark.snp.makeConstraints {
            $0.centerY.equalTo(heartImage.snp.centerY)
            $0.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-20)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        line2.snp.makeConstraints {
            $0.top.equalTo(heartImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(2)
        }
        
        self.setNeedsDisplay()
    }
    
    // MARK: - PlaceHolder 작업
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 254 {
            textView.deleteBackward()
        }
        
        if textView.text == textViewPlaceHolder || textView.text.count == 0 { // Placeholder || 비어있음
            uploadImg.alpha = 0.0
        }else {
            uploadImg.alpha = 1.0
        }
        
        if 100 >= textView.contentSize.height + 20 {
            commentView.snp.remakeConstraints {
                
                $0.centerX.equalToSuperview()
                $0.bottom.left.right.equalToSuperview()
                $0.height.equalTo(textView.contentSize.height + 20)
            }
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            smLog("\(textView)")
        }
        return true
    }
    
    func setCommentTableView(_ commentYN: Bool) {
        if commentYN {
            addSubview(commentView)
            commentView.addSubview(commentTextView)
            commentView.addSubview(uploadImg)
            
            commentView.snp.remakeConstraints {
                
                $0.centerX.equalToSuperview()
                $0.bottom.left.right.equalToSuperview()
                $0.height.equalTo(50)
            }
            commentTextView.snp.remakeConstraints {
                
                $0.top.equalTo(8)
                $0.bottom.equalTo(-8)
                $0.left.equalTo(20)
                $0.right.equalTo(-20)
            }
            uploadImg.snp.remakeConstraints {
                $0.width.height.equalTo(28)
                $0.right.equalTo(-24)
                $0.bottom.equalTo(-11)
//                $0.bottom.equalToSuperview()
//                $0.top.right.equalToSuperview()
            }
            
            //            scrollView.layer.borderWidth = 1
            scrollView.addSubview(commentTableView)
            scrollView.snp.remakeConstraints {
                $0.top.left.right.equalToSuperview()
                $0.bottom.equalTo(commentView.snp.top)
            }
            
            
//            commentTableView.layer.borderWidth = 1
//            commentTableView.layer.borderColor = UIColor.red.cgColor
            commentTableView.backgroundColor = .blue
            commentTableView.snp.makeConstraints {
                $0.top.equalTo(line2.snp.bottom)
                $0.left.right.equalTo(self.safeAreaLayoutGuide)
                //                $0.height.equalTo(800)
            }
        }else {
            commentView.removeFromSuperview()
            commentTableView.removeFromSuperview()
            
            scrollView.snp.remakeConstraints {
                $0.top.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
            }
            self.setNeedsDisplay()
        }
    }
    
    func initImageArr(_ imageArr : [String], completion : @escaping(Bool) -> ()){
        pageControl.numberOfPages = imageArr.count
        
        for i in 0..<imageArr.count{
            let url = URL(string: imageArr[i])
            //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
            //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    let imageview = UIImageView()
                    
                    imageview.kf.indicatorType = .activity
                    imageview.kf.setImage(
                        with: url,
                        placeholder: nil,
                        options: [.transition(.fade(1.2))],
                        completionHandler: nil
                    )
                    
                    imageview.contentMode = .scaleAspectFit
                    imageview.clipsToBounds = true
                    imageview.backgroundColor = .white
                    let xPosition = self.imageViewWidth * CGFloat(i)
                    
                    imageview.frame = CGRect(x: xPosition, y: 0, width: self.imageViewWidth, height: self.imageViewWidth)
                    self.scrollViewHorizontal.contentSize.width = self.imageViewWidth * CGFloat(1+i)
                    
                    self.scrollViewHorizontal.addSubview(imageview)
                }
            }
        }
        completion(true)
    }
    
    func getFeedComment() {
        guard let feedSeq = feedInfo?.feedSeq else { return }
        viewModel.getFeedComment(feedSeq, size)
        viewModel.didFinishFeedCommentFetch = {
            smLog("\(self.viewModel.feedComment)")
            self.feedComment = self.viewModel.feedComment
            
            self.commentTableView.delegate = self
            self.commentTableView.dataSource = self
            self.commentTableView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = round(scrollView.contentOffset.x / imageViewWidth)
        pageControl.currentPage = Int(CGFloat(currentPage))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func followBtnAction(_ sedner: Any) {
        guard let feedInfo = feedInfo, let user = feedInfo.user else { return }
        
        self.delegate?.pushScreen(FollowListTabman(), user.userSeq)
    }
    
    @objc func didSelect(_ sender: UITapGestureRecognizer) {
        guard let feedInfo = feedInfo, let feedSeq = feedInfo.feedSeq, let user = feedInfo.user else { return }
        
        let tag = sender.view?.tag as? Int
        let param : Dictionary<String, Int> = ["feedSeq": feedSeq, "userSeq": getMyUserSeq()]
        
        switch tag {
        case 1: // 프로필 터치
            self.delegate?.pushScreen(ProfileViewController(), user.userSeq)
            
        case 2: // 좋아요 터치
            homeViewModel.feedLikeScarp("like", feedSeq, param)
            homeViewModel.didFinishLikeScrapFetch = {
                UIDevice.vibrate()
                let img = self.heartImage.image
                
                if img!.isEqual(UIImage(systemName: "heart")) {
                    smLog("1")
                    self.heartImage.image = UIImage(systemName: "heart.fill")
                    self.likeCountInt += 1
                    self.likeCount.text = String(self.likeCountInt.commaRepresentation)
                }else {
                    smLog("2")
                    self.heartImage.image = UIImage(systemName: "heart")
                    self.likeCountInt -= 1
                    self.likeCount.text = String(self.likeCountInt.commaRepresentation)
                }
            }
            
        case 3: // 북마크 터치
            homeViewModel.feedLikeScarp("scrap", feedSeq, param)
            homeViewModel.didFinishLikeScrapFetch = {
                UIDevice.vibrate()
                let img = self.bookmark.image
                
                if img!.isEqual(UIImage(systemName: "bookmark")) {
                    toast("스크랩 완료")
                    self.bookmark.image = UIImage(systemName: "bookmark.fill")
                    self.bookmark.tintColor = UIColor.magnifyingGlassColor
                }else {
                    toast("스크랩 취소")
                    self.bookmark.image = UIImage(systemName: "bookmark")
                    self.bookmark.tintColor = UIColor.black
                }
            }
        
        case 4: // 댓글 작성 버튼
            guard let comment = commentTextView.text else {helper.showAlert(vc: self, message: "댓글을 작성해주세요."); return }
            
            let param : Dictionary<String, Any> = [
                "feedSeq": feedSeq,
                "userSeq": getMyUserSeq(),
                "comment": comment,
                "parentCommentSeq": parentCommentSeq
            ]
            
            smLog("\(param)")
            LoadingIndicator.showLoading()
            
            viewModel.commentRegister(param)
            viewModel.didFinishCommentRegisterFetch = {
                self.commentTextView.text = self.textViewPlaceHolder
                self.commentTextView.textColor = .lightGray
                self.commentTextView.resignFirstResponder()
                
                self.getFeedComment()
                
                guard let feedInfo = self.feedInfo else { return }
                self.setUpContent(feedInfo)
            }
            
            UIView.animate(withDuration: 1.0, animations: {
                LoadingIndicator.hideLoading()
            })
        default:
            print("default")
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
}

extension FeedDetailView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.setNeedsDisplay()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feedComment = feedComment, let content = feedComment.content else {return 0}
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let feedComment = feedComment, let content = feedComment.content else {return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        let cellContent = content[indexPath.row]
        cell.delegate = self
        cell.reloadDelegate = self
        cell.comment = cellContent
        
        return cell
    }
}
