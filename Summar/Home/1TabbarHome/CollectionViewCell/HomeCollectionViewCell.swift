//
//  HomeCollectionViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/15.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    let imgProudctPhoto : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor.BackgroundColor
        addSubview(imgProudctPhoto)
        
        imgProudctPhoto.snp.makeConstraints{(make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
