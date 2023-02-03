//
//  HomeView.swift
//  Summar
//
//  Created by mac on 2022/12/14.
// https://hryang.tistory.com/7 => scrollview programmatically

import Foundation
import UIKit

protocol HomeViewDelegate : AnyObject {
    func pushScreen(_ VC: UIViewController,_ any: Any)
}

final class HomeView: UIView, HomeViewDelegate{
    func pushScreen(_ VC: UIViewController, _ any: Any) {
        smLog("")
        if VC == FeedDetailViewController.shared {
            let feedInfo = any as? FeedInfo
            self.homeViewDelegate?.pushScreen(VC, feedInfo)
        }else if VC == ProfileViewController.shared {
            let userSeq = any as? Int
            self.homeViewDelegate?.pushScreen(VC, userSeq)
        }
    }
    
    let helper = Helper.shared
    private let tableCellReuseIdentifier = "tableCell"
    private let bannerCellReuseIdentifier = "bannerCell"
    
    weak var homeViewDelegate : HomeViewDelegate?
    
    var displayCount : Int = 0
    var pageIndex : Int = 1
    
    let viewWidth : CGFloat = {
        let width = UIScreen.main.bounds.width
        return width - 40
    }()
    
    var model : FeedSelectResponse? {
        didSet {
            smLog("\n \(self.model?.content?.count) \n")
            
            tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: tableCellReuseIdentifier)
            tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: bannerCellReuseIdentifier)
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.reloadData()
        }
    }
    
    
    let tableView : UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        
        // 테이블뷰 왼쪽 마진 없애기
        view.separatorStyle = .none
//        view.separatorStyle = .singleLine
//        view.cellLayoutMarginsFollowReadableWidth = false
//        view.separatorInset.left = 0
//        view.separatorColor = .gray
        //
        
        view.estimatedRowHeight = 85.0
        view.rowHeight = UITableView.automaticDimension
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(selectFeed), for: .valueChanged)
        view.refreshControl = refreshControl
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
    }
    
    @objc func selectFeed() {
        let viewModel = HomeViewModel(0, (pageIndex * 30))
        viewModel.selectFeed()
        viewModel.didFinishFetch = {
            self.model = viewModel.feedSelectResponse
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 115
        }else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let totalRecordCount = model?.totalRecordCount, let recordsPerPage = model?.recordsPerPage, let currentPageNo = model?.currentPageNo, let totalPageCount = model?.totalPageCount {
            if totalRecordCount < 30 { // 30개 미만일때는 총 건수만 return
                return totalRecordCount + 1 // "+1" 은 위에 홈 배너를 위함
            }else { // 30개 이상일때
                if currentPageNo != totalPageCount { // 총건수를 30으로 나눴을때 현재페이지 != 마지막페이지
                    displayCount = 30 * pageIndex
                    return displayCount + 1 // "+1" 은 위에 홈 배너를 위함 / 30개씩 * 현재페이지 ex) 120건 노출시 30.. 60.. 90.. 120...
                }else { // 총건수를 30으로 나눴을때 현재페이지 == 마지막페이지
                    displayCount = (30 * (pageIndex - 1)) + (totalRecordCount % 30)
                    return displayCount + 1 // "+1" 은 위에 홈 배너를 위함 / (30개씩 * 현재페이지) + 나머지(총 건수 % 30건)
                }
            }
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! HomeTableViewCell
            guard let model = model?.content?[indexPath.row - 1] else{ return UITableViewCell() }
            cell.setUpCell(model)
            cell.delegate = self
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: bannerCellReuseIdentifier, for: indexPath) as! BannerTableViewCell
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("indexPath.row => ", indexPath.row)
//        print("displayCount => ", displayCount)
//        print("pageIndex => ", pageIndex)
//        print("")
        
        if let totalRecordCount = model?.totalRecordCount, let recordsPerPage = model?.recordsPerPage, let currentPageNo = model?.currentPageNo, let totalPageCount = model?.totalPageCount {
            if pageIndex * 30 == indexPath.row {
                self.pageIndex += 1
                let viewModel = HomeViewModel(0, (pageIndex * 30))
                viewModel.selectFeed()

                viewModel.didFinishFetch = {
                    self.model = viewModel.feedSelectResponse
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = model?.content {
            homeViewDelegate?.pushScreen(FeedDetailViewController.shared, model[indexPath.row - 1])
        }
    }
    
}
