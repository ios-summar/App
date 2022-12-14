//
//  HomeView.swift
//  Summar
//
//  Created by mac on 2022/12/14.
// https://hryang.tistory.com/7 => scrollview programmatically

import Foundation
import UIKit

class HomeView: UIView{
    static let shared = HomeView()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let view1 = UIView()
    let view2 = UIView()
    let view3 = UIView()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView) // 메인뷰에
                
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview() // 스크롤뷰가 표현될 영역
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        _ = [view1, view2, view3].map { self.contentView.addSubview($0)}
        
        view1.backgroundColor = .red
        view2.backgroundColor = .black
        view3.backgroundColor = .blue
        
        
        view1.snp.makeConstraints { (make) in
            
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        view2.snp.makeConstraints { (make) in
            
            make.top.equalTo(view1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        view3.snp.makeConstraints { (make) in
            
            make.top.equalTo(view2.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview() // 이것이 중요함
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

