//
//  FullScreenImageView.swift
//  Summar
//
//  Created by ukBook on 2022/12/31.
//

import Foundation
import UIKit

class FullScreenImageView : UIView, UIScrollViewDelegate{
    static let shared = FullScreenImageView()
    
    var imageArr = [UIImage]()
    
    let viewWidth : CGFloat = {
        var btnWidth = UIScreen.main.bounds.width
        return btnWidth
    }()
    
    let helper = Helper()
    
    let view1 : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // Define the number of pages.
//    let pageSize = arrProductPhotos.count
    
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
        pageControl.currentPageIndicatorTintColor = UIColor.black
        
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
    
    
//    let imageView : UIImageView = {
//        let imageView = UIImageView()
//        imageView.layer.borderWidth = 1
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
    
    lazy var label1 : UILabel = {
        let label = UILabel()
//        label.text = "1/\(self.arrProductPhotos.count)"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let label2 : UILabel = {
        let label = UILabel()
        label.text = "대표 이미지"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(view1)
        view1.layer.borderWidth = 1
//        view1.layer.borderColor = UIColor.red.cgColor
        
        _ = [label1, scrollView, pageControl, label2].map {
            view1.addSubview($0)
            $0.layer.borderWidth = 1
        }
        
        
        view1.snp.makeConstraints{(make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(0)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        label2.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
        
        label1.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(label2.snp.bottom)
        }
        
        scrollView.snp.makeConstraints{(make) in
            make.left.equalToSuperview()
            make.width.equalTo(viewWidth)
            make.top.equalTo(label1.snp.bottom).offset(20)
            make.height.equalTo(600)
        }

        pageControl.snp.makeConstraints{(make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(scrollView.snp.bottom)
            make.height.equalTo(30)
        }
        
    }
    
    func initImageArr(imageArr : [UIImage]){
        print("imageArr \(imageArr)")
        self.imageArr = imageArr
        pageControl.numberOfPages = self.imageArr.count
        
        label1.text = "1/\(self.imageArr.count)"
        
        for i in 0..<self.imageArr.count{
            let imageview = UIImageView()
            imageview.image = self.imageArr[i]
            imageview.contentMode = .scaleAspectFit
            imageview.clipsToBounds = true
            let xPosition = viewWidth * CGFloat(i)
            
            imageview.frame = CGRect(x: xPosition, y: 0, width: viewWidth, height: 600)
            print(imageview)
            
            scrollView.contentSize.width = viewWidth * CGFloat(1+i)
            
            scrollView.addSubview(imageview)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = round(scrollView.contentOffset.x / viewWidth)
        label1.text = "\(Int(currentPage + 1))/\(self.imageArr.count)"
        pageControl.currentPage = Int(CGFloat(currentPage))
        
        if currentPage == 0 {
            label2.layer.opacity = 1.0
        }else{
            label2.layer.opacity = 0.0
        }
    }
}
