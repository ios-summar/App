//
//  PortFolioTableViewCell.swift
//  Summar
//
//  Created by plsystems on 2023/02/07.
//

import Foundation

import UIKit

final class PortFolioTableViewCell: UITableViewCell, UIScrollViewDelegate, ViewAttributes {
    weak var delegate : PushDelegate?
    let helper = Helper()
    let fontManger = FontManager()
    let viewModel = HomeViewModel(nil, nil)
    
    var feedInfo: FeedInfo?
    var userSeq: Int?
    var feedSeq: Int?
    var likeCountInt: Int = 0
    var imageArr = [String]()
    var feedImages : [FeedImages]? {
        didSet {
            guard let image = feedImages else {return}
            
            for i in 0 ..< image.count {
                imageArr.append(image[i].imageUrl!)
            }
            
            initImageArr(imageArr) { finish in
                if finish {
                    self.imageArr = []
                }
            }
        }
    }
    
    let imageViewWidth : CGFloat = {
        let width = UIScreen.main.bounds.width
        return width - 40
    }()
    let uiView: UIView = {
        let view = UIView()
//        view.intrinsicContentSize
        return view
    }()
    lazy var lockImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "lock.fill")
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var meetballMenu: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "meetballMenu")
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelectImg(_:))
        )
        view.addGestureRecognizer(recognizer)
        view.tag = 1
        
        return view
    }()
    let view = UIView()
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
    let contentsLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = FontManager.getFont(Font.Regular.rawValue).medium15Font
        UILabel.textColor = UIColor.homeContentsColor
        UILabel.textAlignment = .left
        UILabel.numberOfLines = 3
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
    
    lazy var scrollView: UIScrollView = {
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
        scrollView.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelectImg(_:))
        )
        scrollView.addGestureRecognizer(recognizer)
        scrollView.tag = 2
        
        // Specify the screen size of the scroll.
        //        scrollView.contentSize = CGSize(width: CGFloat(pageSize) * self.view.frame.maxX, height: 0)
        
        return scrollView
    }()
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray01
        return view
    }()
    
    @objc func didSelect(_ sender: UITapGestureRecognizer) {
        guard let feedSeq = feedInfo?.feedSeq else {return}
        let tag = sender.view?.tag as? Int
        let param : Dictionary<String, Int> = ["feedSeq": feedSeq, "userSeq": getMyUserSeq()]
        
        switch tag {
        case 1: // 프로필 터치
            guard let userSeq = userSeq else {return}
            self.delegate?.pushScreen(ProfileViewController(), userSeq)
            
        case 2: // 좋아요 터치
            viewModel.feedLikeScarp("like", feedSeq, param)
            viewModel.didFinishLikeScrapFetch = {
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
            viewModel.feedLikeScarp("scrap", feedSeq, param)
            viewModel.didFinishLikeScrapFetch = {
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
            
        default:
            print("default")
        }
    }
    
    @objc func didSelectImg(_ sender: UITapGestureRecognizer) {
        guard let feedInfo = feedInfo else {return}
        let tagNum = sender.view?.tag
        
        switch tagNum {
        case 1:
            self.delegate?.pushScreen(WriteFeedController(), feedInfo)
        case 2:
            self.delegate?.pushScreen(FeedDetailViewController(), feedInfo)
        default:
            print("default")
        }
    }
    
    func setUpCell(_ feedInfo: FeedInfo){
        print("setUpCell \(feedInfo)")
        guard let user = feedInfo.user, let major2 = user.major2, let secretYn = feedInfo.secretYn, let likeYn = feedInfo.likeYn, let commentYn = feedInfo.commentYn, let totalLikeCount = feedInfo.totalLikeCount, let totalCommentCount = feedInfo.totalCommentCount, let scrapYn = feedInfo.scrapYn else { return }
        self.feedInfo = feedInfo
        userSeq = user.userSeq

//        feedInfo.secretYn ? lockImage.alpha = 1.0 : lockImage.alpha = 0.0
        lockImage.alpha = secretYn ? 1.0 : 0.0
        // 피드 이미지 Array
        feedImages = feedInfo.feedImages
        
        //피드내용
        contentsLabel.text = feedInfo.contents
        helper.lineSpacing(contentsLabel, 5)
        
        // 좋아요
        guard let image = likeYn ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart") else {return}
        heartImage.image = image
        
        // 좋아요 카운트
        likeCountInt = totalLikeCount
        likeCount.text = String(likeCountInt.commaRepresentation)
        
        if commentYn {
            // 댓글 카운트
            commentCount.text = String(totalCommentCount.commaRepresentation)
            bubbleImage.alpha = 1.0
            commentCount.alpha = 1.0
        }else {
            bubbleImage.alpha = 0.0
            commentCount.alpha = 0.0
        }
        
        
        // 북마크
        guard let image = scrapYn ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark") else {return}
        
        bookmark.image = image
        if scrapYn {
            bookmark.tintColor = UIColor.magnifyingGlassColor
        }else {
            bookmark.tintColor = .black
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .Gray01
        
        setUI()
        setAttributes()
    }
    
    func setUI() {
        contentView.addSubview(uiView)
        
        // 자물쇠 이미지, 미트볼
        uiView.addSubview(lockImage)
        uiView.addSubview(meetballMenu)
        
        //이미지
        uiView.addSubview(view)
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        
        // 좋아요, 댓글, 북마크
        uiView.addSubview(heartImage)
        uiView.addSubview(likeCount)
        
        uiView.addSubview(bubbleImage)
        uiView.addSubview(commentCount)
        uiView.addSubview(bookmark)

        // 피드 내용
        uiView.addSubview(contentsLabel)
        uiView.addSubview(line)
    }
    
    func setAttributes() {
        uiView.snp.makeConstraints { (make) in
            
            make.edges.equalToSuperview()
        }
        lockImage.snp.makeConstraints { (make) in
            
            make.top.left.equalTo(20)
            make.width.height.equalTo(24)
        }
        meetballMenu.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(lockImage.snp.centerY)
            make.right.equalTo(-20)
            make.width.height.equalTo(24)
        }
        view.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(lockImage.snp.bottom).offset(10)
            make.width.equalTo(imageViewWidth)
            make.height.equalTo(imageViewWidth)
        }
        scrollView.snp.makeConstraints { (make) in
            
            make.edges.equalToSuperview()
        }
        pageControl.snp.makeConstraints { (make) in
            
            make.height.equalTo(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-15)
        }
        heartImage.snp.makeConstraints {
            
            $0.top.equalTo(view.snp.bottom).offset(13)
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
            $0.right.equalTo(-20)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        contentsLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(heartImage.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.right.equalTo(-20)
//            make.bottom.equalTo(-20)
        }
        line.snp.makeConstraints { (make) in
            
            make.top.equalTo(contentsLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(16)
            make.bottom.equalTo(0)
        }
        //
        //        self.layoutIfNeeded()
        //        self.setNeedsDisplay()
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
                    imageview.contentMode = .scaleAspectFill
                    imageview.backgroundColor = .white
                    imageview.clipsToBounds = true
                    
                    imageview.kf.indicatorType = .activity
                    imageview.kf.setImage(
                        with: url,
                        placeholder: nil,
                        options: [.transition(.fade(1.2))],
                        completionHandler: nil
                    )
                    
                    let xPosition = self.imageViewWidth * CGFloat(i)
                    
                    imageview.frame = CGRect(x: xPosition, y: 0, width: self.imageViewWidth, height: self.imageViewWidth)
                    self.scrollView.contentSize.width = self.imageViewWidth * CGFloat(1+i)
                    
                    self.scrollView.addSubview(imageview)
                }
            }
        }
        completion(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = round(scrollView.contentOffset.x / imageViewWidth)
        pageControl.currentPage = Int(CGFloat(currentPage))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        // table view margin
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
}
