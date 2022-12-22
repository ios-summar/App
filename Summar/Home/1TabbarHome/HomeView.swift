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
    let helper = Helper.shared
    private let tableCellReuseIdentifier = "tableCell"
    private let bannerCellReuseIdentifier = "bannerCell"
    
    var arr: Array<Feed> = []
    
    let Feed1 = Feed()
    let Feed2 = Feed()
    let Feed3 = Feed()
    let Feed4 = Feed()
    
    var arrProductPhotos = [
        UIImage(systemName: "doc"),
        UIImage(systemName: "doc.fill"),
        UIImage(systemName: "doc.circle"),
        UIImage(systemName: "square.and.arrow.up"),
        UIImage(systemName: "square.and.arrow.up.circle"),
        UIImage(systemName: "square.and.arrow.up.circle.fill"),
        UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark"),
        UIImage(systemName: "square.and.arrow.down")
    ]
    var timer : Timer?
    var currentCelIndex = 0
    
    
    // 이미지 슬라이더
    let view1 = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.layer.cornerRadius = 7
        return cv
    }()
    
    let view3 = UIView()
    let view3TableView : UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        return view
    }()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = [view3].map { self.contentView.addSubview($0)}
        
        addSubview(scrollView) // 메인뷰에
        self.scrollView.addSubview(contentView)
        
        self.view3.addSubview(view3TableView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview() // 스크롤뷰가 표현될 영역
        }
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        view3.snp.makeConstraints { (make) in

            make.top.equalTo(0)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(1000)
            make.bottom.equalToSuperview() // 이것이 중요함
        }

        view3TableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        //홈화면 이미지 슬라이더
        testFeed()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource{
    // MARK: - 피드
    func testFeed(){
        arr.append(Feed1)
        arr.append(Feed2)
        arr.append(Feed3)
        arr.append(Feed4)
        
        view3TableView.register(HomeTableViewCell.self, forCellReuseIdentifier: tableCellReuseIdentifier)
        view3TableView.register(BannerTableViewCell.self, forCellReuseIdentifier: bannerCellReuseIdentifier)
        
        view3TableView.delegate = self
        view3TableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 {
            return 240
        }else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 0 {
            let cell = view3TableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! HomeTableViewCell
            cell.nickName.text = "욱승"
            cell.major.text = "컴퓨터 / 통신"
            cell.introductLabel.text = "introductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabel"
            helper.lineSpacing(cell.introductLabel, 10)
            return cell
        }else {
            let cell = view3TableView.dequeueReusableCell(withIdentifier: bannerCellReuseIdentifier, for: indexPath) as! BannerTableViewCell
            return cell
        }
    }
}
