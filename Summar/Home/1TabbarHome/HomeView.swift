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

final class HomeView: UIView, HomeViewDelegate, ViewAttributes{
    weak var delegate: ScrollBarHidden?
    weak var homeViewDelegate : HomeViewDelegate?
    func pushScreen(_ VC: UIViewController, _ any: Any) {
        if VC.isKind(of: FeedDetailViewController.self) {
            let feedInfo = any as? FeedInfo
            self.homeViewDelegate?.pushScreen(VC, feedInfo)
        }else if VC.isKind(of: ProfileViewController.self) {
            let userSeq = any as? Int
            self.homeViewDelegate?.pushScreen(VC, userSeq)
        }
    }
    
    let helper = Helper.shared
    let viewModel = HomeViewModel()
    private let tableCellReuseIdentifier = "tableCell"
    private let bannerCellReuseIdentifier = "bannerCell"
    
    
    var displayCount : Int = 0
    var sizeIndex : Int = 1
    
    let viewWidth : CGFloat = {
        let width = UIScreen.main.bounds.width
        return width - 40
    }()
    
    var model : FeedSelectResponse? {
        didSet {
            smLog("\n \(self.model?.content?.count) \n")
            
//            for in 0..<model?.content?.count {
//                
//            }
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    
    
    lazy var tableView : UITableView = {
        let view = UITableView()
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
        view.register(BannerTableViewCell.self, forCellReuseIdentifier: "BannerTableViewCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .Gray01
        
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
        
        setDelegate()
        setUI()
        setAttributes()
    }
    
    func setDelegate() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: NSNotification.Name("scroll"), object: nil)
    }
    
    func setUI() {
        
        addSubview(tableView)
    }
    
    func setAttributes() {
        
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
    }
    
    @objc func selectFeed() {
        self.viewModel.selectFeed(pageIndex: 0, size: sizeIndex * 30)
        self.viewModel.didFinishFetch = {
            self.model = self.viewModel.feedSelectResponse
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func scrollToTop() {
        
        smLog("")
        tableView.scrollsToTop = true
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
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
                    displayCount = 30 * sizeIndex
                    return displayCount + 1 // "+1" 은 위에 홈 배너를 위함 / 30개씩 * 현재페이지 ex) 120건 노출시 30.. 60.. 90.. 120...
                }else { // 총건수를 30으로 나눴을때 현재페이지 == 마지막페이지
                    displayCount = (30 * (sizeIndex - 1)) + (totalRecordCount % 30)
                    return displayCount + 1 // "+1" 은 위에 홈 배너를 위함 / (30개씩 * 현재페이지) + 나머지(총 건수 % 30건)
                }
            }
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
            guard let model = model?.content?[indexPath.row - 1] else{ return UITableViewCell() }
            cell.setUpCell(model)
            cell.delegate = self
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as! BannerTableViewCell
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
            if sizeIndex * 30 == indexPath.row {
                self.sizeIndex += 1
                
                self.viewModel.selectFeed(pageIndex: 0, size: sizeIndex * 30)
                self.viewModel.didFinishFetch = {
                    self.model = self.viewModel.feedSelectResponse
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = model?.content {
            homeViewDelegate?.pushScreen(FeedDetailViewController(), model[indexPath.row - 1])
        }
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        
//        if(velocity.y>0) {
//            self.delegate?.scrollBarInterAction(true)
//        } else {
//            self.delegate?.scrollBarInterAction(false)
//        }
//    }
    
}
