//
//  HomeTableViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell, UIScrollViewDelegate {
    let helper = Helper()
    
    let imageViewWidth : CGFloat = {
        let width = UIScreen.main.bounds.width
        return width - 40
    }()
    
    lazy var imageViewHeight : CGFloat = {
        return self.imageViewWidth * 0.5415
    }()
    
    var testPhotos : [UIImage] = [
        UIImage(systemName: "doc")!,
        UIImage(systemName: "doc.fill")!,
        UIImage(systemName: "doc.circle")!,
        UIImage(systemName: "square.and.arrow.up")!,
        UIImage(systemName: "square.and.arrow.up.circle")!,
        UIImage(systemName: "square.and.arrow.up.circle.fill")!,
        UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")!,
        UIImage(systemName: "square.and.arrow.down")!
    ]
    
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
    let contentsLabel : UILabel = {
        let UILabel = UILabel()
        UILabel.font = .systemFont(ofSize: 14)
        UILabel.textColor = UIColor.homeContentsColor
        UILabel.textAlignment = .left
        UILabel.numberOfLines = 3
        UILabel.lineBreakMode = .byTruncatingTail
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
            
            make.top.equalTo(10)
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
            make.height.equalTo(100)
        }
        scrollView.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(contentsLabel.snp.bottom).offset(10)
            make.width.equalTo(imageViewWidth)
            make.height.equalTo(imageViewHeight)
        }
        scrollView.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(contentsLabel.snp.bottom).offset(10)
            make.width.equalTo(imageViewWidth)
            make.height.equalTo(imageViewHeight)
        }
        pageControl.snp.makeConstraints { (make) in
            
            make.top.equalTo(scrollView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        initImageArr(testPhotos)
    }
    
    func initImageArr(_ imageArr : [UIImage]){
        pageControl.numberOfPages = imageArr.count
        
        for i in 0..<imageArr.count{
            let imageview = UIImageView()
            imageview.image = imageArr[i]
            imageview.contentMode = .scaleAspectFit
            imageview.clipsToBounds = true
            let xPosition = imageViewWidth * CGFloat(i)
            
            imageview.frame = CGRect(x: xPosition, y: 0, width: imageViewWidth, height: imageViewHeight)
            scrollView.contentSize.width = imageViewWidth * CGFloat(1+i)
            
            scrollView.addSubview(imageview)
        }
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
          contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }

}
