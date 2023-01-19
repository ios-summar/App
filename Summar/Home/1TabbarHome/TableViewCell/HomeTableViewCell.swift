//
//  HomeTableViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell, UIScrollViewDelegate {
    let helper = Helper()
    
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
    
    lazy var imageViewHeight : CGFloat = {
        return self.imageViewWidth * 0.5415
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
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    let major : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    lazy var contentsLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .systemFont(ofSize: 14)
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
        pageControl.currentPageIndicatorTintColor = UIColor.summarColor2
        
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
        
        // Specify the screen size of the scroll.
//        scrollView.contentSize = CGSize(width: CGFloat(pageSize) * self.view.frame.maxX, height: 0)
        
        return scrollView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(profileImg)
        contentView.addSubview(nickName)
        contentView.addSubview(major)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(scrollView)
        contentView.addSubview(pageControl)
        
//        scrollView.layer.borderWidth = 1
//        pageControl.layer.borderWidth = 1
        
        profileImg.snp.makeConstraints { (make) in
            
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.width.height.equalTo(40)
        }
        nickName.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(profileImg.snp.centerY).offset(-1)
            make.left.equalTo(profileImg.snp.right).offset(10)
        }
        major.snp.makeConstraints { (make) in
            
            make.top.equalTo(profileImg.snp.centerY).offset(2)
            make.left.equalTo(profileImg.snp.right).offset(10)
        }
        contentsLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(profileImg.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
//            make.height.equalTo(100)
        }
        scrollView.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(contentsLabel.snp.bottom).offset(30)
            make.width.equalTo(imageViewWidth)
            make.height.equalTo(imageViewHeight)
        }
        pageControl.snp.makeConstraints { (make) in
            
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-20)
        }
    }
    
    func initImageArr(_ imageArr : [String], completion : @escaping(Bool) -> ()){
            pageControl.numberOfPages = imageArr.count
            
            for i in 0..<imageArr.count{
                let url = URL(string: imageArr[i])
                //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
                //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
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
                        let xPosition = self.imageViewWidth * CGFloat(i)
                        
                        imageview.frame = CGRect(x: xPosition, y: 0, width: self.imageViewWidth, height: self.imageViewHeight)
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
//              contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        }

    }
