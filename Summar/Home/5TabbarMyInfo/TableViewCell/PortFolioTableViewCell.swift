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
    
    var feedInfo: FeedInfo?
    var userSeq: Int?
    var feedSeq: Int?
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
        guard let user = feedInfo.user, let major2 = user.major2, let secretYn = feedInfo.secretYn else { return }
        self.feedInfo = feedInfo
        userSeq = user.userSeq

//        feedInfo.secretYn ? lockImage.alpha = 1.0 : lockImage.alpha = 0.0
        lockImage.alpha = secretYn ? 1.0 : 0.0
        contentsLabel.text = feedInfo.contents
        
        feedImages = feedInfo.feedImages
        helper.lineSpacing(contentsLabel, 5)
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
        uiView.addSubview(lockImage)
        uiView.addSubview(meetballMenu)
        uiView.addSubview(view)
        view.addSubview(scrollView)
        view.addSubview(pageControl)
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
        contentsLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(view.snp.bottom).offset(20)
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
                    imageview.contentMode = .scaleAspectFit
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
