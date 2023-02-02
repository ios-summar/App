//
//  HomeTableViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/21.
//

import UIKit

final class HomeTableViewCell: UITableViewCell, UIScrollViewDelegate {
    weak var delegate : HomeViewDelegate?
    
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
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didSelect(_:))
        )
        label.addGestureRecognizer(recognizer)
        return label
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
        guard let userSeq = userSeq else {return}
        self.delegate?.pushScreen(ProfileViewController.shared, userSeq)
    }
    
    @objc func didSelectImg(_ sender: UITapGestureRecognizer) {
        guard let feedInfo = feedInfo else {return}
        self.delegate?.pushScreen(FeedDetailViewController.shared, feedInfo)
    }
    
    func setUpCell(_ feedInfo: FeedInfo){
//        print("setUpCell \(feedInfo)")
        guard let user = feedInfo.user, let major2 = user.major2 else { return }
        self.feedInfo = feedInfo
        userSeq = user.userSeq
        
        setProfileImage(profileImg, user.profileImageUrl)
        nickName.text = user.userNickname
        major.text = "\(major2) / \(compareDate(feedInfo.createdDate))"
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
        
        contentView.addSubview(profileImg)
        contentView.addSubview(nickName)
        contentView.addSubview(major)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(scrollView)
        contentView.addSubview(pageControl)
        contentView.addSubview(line)
        
        profileImg.snp.makeConstraints { (make) in
            
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.width.height.equalTo(40)
        }
        nickName.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(profileImg.snp.centerY).offset(-1)
            make.left.equalTo(profileImg.snp.right).offset(12)
        }
        major.snp.makeConstraints { (make) in
            
            make.top.equalTo(profileImg.snp.centerY).offset(2)
            make.left.equalTo(profileImg.snp.right).offset(12)
        }
        
        scrollView.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImg.snp.bottom).offset(20)
            make.width.equalTo(imageViewWidth)
            make.height.equalTo(imageViewWidth)
        }
        pageControl.snp.makeConstraints { (make) in
            
            make.top.equalTo(scrollView.snp.bottom).offset(-36)
            make.left.right.equalToSuperview()
        }
        
        contentsLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.width.equalTo(imageViewWidth)
        }
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(contentsLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(16)
            make.bottom.equalTo(0)
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 4
        label.lineBreakMode = .byCharWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        print(label.frame.height)
        contentsLabel.snp.updateConstraints {
            $0.height.equalTo(label.frame.height)
        }
        return label.frame.height
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
//              contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
        }

    }
