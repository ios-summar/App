//
//  FeedDetailView.swift
//  Summar
//
//  Created by ukBook on 2023/01/22.
//

import Foundation
import UIKit

final class FeedDetailView: UIView, ViewAttributes, UIScrollViewDelegate {
    
    static let shared = FeedDetailView()
    let viewModel = FeedDetailViewModel()
    let helper = Helper.shared
    
    let imageViewWidth : CGFloat = {
        let width = UIScreen.main.bounds.width
        return width - 40
    }()
    var imageArr = [String]()
    var feedInfo : FeedInfo? {
        didSet {
            guard let feedInfo = feedInfo, let feedSeq = feedInfo.feedSeq else { return }
            smLog("\n \(feedInfo)")
            
            // 피드 프로필 Set
            viewModel.getFeedInfo(feedSeq)
            viewModel.didFinishFetch = {
                guard let commentYn = self.viewModel.commentYn else {return}
                let alphaCGFloat = commentYn ? 1.0 : 0.0
                
                // 댓글 막아놓음
                self.bubbleImage.alpha = alphaCGFloat
                self.commentCount.alpha = alphaCGFloat
                
                // 댓글 활성화 => addSubView
                self.setCommentTableView(commentYn)
                
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
            }
        }
    }
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray01
        return view
    }()
    lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
//        view.contentSize = CGSize(width: self.frame.width, height: 1200)
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
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        view.layer.cornerRadius = 20
        view.image = UIImage(named: "NonProfile")
        view.tintColor = UIColor.grayColor205
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    let nickName : UILabel = {
        let label = UILabel()
        label.font = FontManager.getFont(Font.Bold.rawValue).medium15Font
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

    let heartImage : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "heart")
        view.tintColor = .black
        return view
    }()
    let likeCount : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        label.sizeToFit()
        return label
    }()
    let bubbleImage : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bubble")
        view.tintColor = .black
        return view
    }()
    let commentCount : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        label.sizeToFit()
        return label
    }()
    lazy var commentTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        
        // 테이블뷰 왼쪽 마진 없애기
        view.separatorStyle = .none
        view.estimatedRowHeight = 132
        view.rowHeight = UITableView.automaticDimension
        view.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        view.dataSource = self
        view.delegate = self
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
    lazy var commentTextField: UITextField = {
        let view = PaddingTextField()
        view.placeholder = "댓글을 입력해 주세요."
        view.backgroundColor = UIColor.Gray02
        view.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
        view.textColor = .black
        view.layer.cornerRadius = 23
        return view
    }()
    
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
        
        scrollView.addSubview(line2)
    }
    
    func setAttributes() {
        line.snp.makeConstraints {
            
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(2)
        }
        scrollView.snp.makeConstraints {
            
            $0.top.equalTo(line.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
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
        line2.snp.makeConstraints {
            $0.top.equalTo(heartImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(2)
        }
        
        scrollView.updateContentSize()
        
        self.setNeedsDisplay()
    }
    
    func setCommentTableView(_ commentYN: Bool) {
        if commentYN {
            addSubview(commentView)
            commentView.addSubview(commentTextField)
            commentView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.left.right.equalToSuperview()
                $0.height.equalTo(62)
            }
            commentTextField.snp.makeConstraints {
                $0.top.equalTo(8)
                $0.bottom.equalTo(-8)
                $0.left.equalTo(20)
                $0.right.equalTo(-20)
            }
            
            scrollView.addSubview(commentTableView)
            scrollView.snp.remakeConstraints {
                $0.top.left.right.equalToSuperview()
                $0.bottom.equalTo(commentView.snp.top)
            }
            commentTableView.backgroundColor = .blue
            commentTableView.snp.makeConstraints {
                $0.top.equalTo(line2.snp.bottom).offset(12)
                $0.centerX.equalToSuperview()
                $0.height.width.equalTo(400)
            }
            scrollView.updateContentSize()
        }else {
            commentView.removeFromSuperview()
            commentTableView.removeFromSuperview()
            
            scrollView.snp.remakeConstraints {
                $0.top.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
            }
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
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = round(scrollView.contentOffset.x / imageViewWidth)
        pageControl.currentPage = Int(CGFloat(currentPage))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func followBtnAction(_ sedner: Any) {
        smLog("")
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.TEST()
        scrollView.updateContentSize()
        return cell
    }
}
