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
    
    let tableView : UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .grayColor197
        
        // 테이블뷰 왼쪽 마진 없애기
        view.separatorStyle = .none
//        view.separatorStyle = .singleLine
//        view.cellLayoutMarginsFollowReadableWidth = false
//        view.separatorInset.left = 0
//        view.separatorColor = .gray
        //
        
        view.estimatedRowHeight = 85.0
        view.rowHeight = UITableView.automaticDimension
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
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
//        arr.append(Feed2)
//        arr.append(Feed3)
//        arr.append(Feed4)
        
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: tableCellReuseIdentifier)
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: bannerCellReuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
//        view3TableView.sectionFooterHeight = 20
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row != 0 {
//            return 440
//        }else {
//            return 100
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! HomeTableViewCell
            cell.backgroundColor = .grayColor197
            
            cell.nickName.text = "욱승"
            cell.major.text = "컴퓨터 / 통신"
            cell.contentsLabel.text = "베니테이블 온보딩 웰컴키트를 제작하면서 실용성과 소속감이 느껴지는 메세지를 전달하기 위해 많은 고민을 했습니다. 성공적인 아침을 열어나가기 위한 베니테이블 모닝루틴 라이프. 베니테이블 온보딩 웰컴키트를 제작하면서 실용성과 "
            helper.lineSpacing(cell.contentsLabel, 10)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: bannerCellReuseIdentifier, for: indexPath) as! BannerTableViewCell
            cell.backgroundColor = .grayColor197
            cell.selectionStyle = .none
            
            return cell
        }
    }
}
