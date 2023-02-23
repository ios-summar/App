//
//  ClippingView.swift
//  Summar
//
//  Created by plsystems on 2023/02/08.
//

import Foundation
import UIKit

final class ClippingView: UIView, ViewAttributes, HomeViewDelegate {
    weak var delegate: HomeViewDelegate?
    let fontManager = FontManager.shared
    let viewModel = ClippingViewModel()
    
    func pushScreen(_ VC: UIViewController, _ any: Any) {
        if VC.isKind(of: FeedDetailViewController.self) {
            let feedInfo = any as? FeedInfo
            self.delegate?.pushScreen(VC, feedInfo)
        }else if VC.isKind(of: ProfileViewController.self) {
            let userSeq = any as? Int
            self.delegate?.pushScreen(VC, userSeq)
        }
    }
    
    var displayCount : Int = 0
    var sizeIndex : Int = 1
    
    let viewWidth : CGFloat = {
        
        let width = UIScreen.main.bounds.width
        return width - 40
    }()
    
    var model : FeedSelectResponse? {
        didSet {
            guard let count = model?.content?.count else {return}
            smLog("\n \(self.model?.content?.count) \n")

            if count > 0 {
                tableView.alpha = 1.0
                view.alpha = 0.0
                
                tableView.delegate = self
                tableView.dataSource = self

                tableView.reloadData()
            }else {
                tableView.alpha = 0.0
                view.alpha = 1.0
            }
        }
    }
    lazy var tableView : UITableView = {
        let view = UITableView()
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.Gray01
        
        // 테이블뷰 왼쪽 마진 없애기
        view.separatorStyle = .none
        
        view.estimatedRowHeight = 85.0
        view.rowHeight = UITableView.automaticDimension
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(selectFeed), for: .valueChanged)
        view.refreshControl = refreshControl
        return view
    }()
    lazy var view: UIView = {
        let view = UIView()
        view.alpha = 0.0
        return view
    }()
    lazy var noImage : UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NoCount")
        return imageView
    }()
    lazy var noLabel : UILabel = {
        
        let UILabel = UILabel()
        UILabel.textColor = .black
        UILabel.font = self.fontManager.getFont(Font.SemiBold.rawValue).mediumFont
        UILabel.sizeToFit()
        UILabel.text = "저장된 스크랩이 없습니다.\n포트폴리오를 스크랩해 모아보세요!"
        return UILabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAttributes()
    }
    
    func setUI() {
        addSubview(tableView)
        addSubview(view)
        view.addSubview(noImage)
        view.addSubview(noLabel)
    }
    
    func setAttributes() {
        tableView.snp.makeConstraints {

            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        view.snp.makeConstraints {
            
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(80)
            $0.width.equalTo(200)
            $0.height.equalTo(250)
            $0.centerX.equalToSuperview()
        }
        noImage.snp.makeConstraints {
            
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(80)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(194)
        }
        noLabel.snp.makeConstraints {
            
            $0.top.equalTo(noImage.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func selectFeed() {
        viewModel.scrapFeed(pageIndex: 0, size: sizeIndex * 30)
        viewModel.didFinishFetch = {
            self.model = self.viewModel.feedSelectResponse
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClippingView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let totalRecordCount = model?.totalRecordCount, let recordsPerPage = model?.recordsPerPage, let currentPageNo = model?.currentPageNo, let totalPageCount = model?.totalPageCount {
            if totalRecordCount < 30 { // 30개 미만일때는 총 건수만 return
                return totalRecordCount
            }else { // 30개 이상일때
                if currentPageNo != totalPageCount { // 총건수를 30으로 나눴을때 현재페이지 != 마지막페이지
                    displayCount = 30 * sizeIndex
                    return displayCount// 30개씩 * 현재페이지 ex) 120건 노출시 30.. 60.. 90.. 120...
                }else { // 총건수를 30으로 나눴을때 현재페이지 == 마지막페이지
                    displayCount = (30 * (sizeIndex - 1)) + (totalRecordCount % 30)
                    return displayCount// (30개씩 * 현재페이지) + 나머지(총 건수 % 30건)
                }
            }
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        guard let model = model?.content?[indexPath.row] else{ return UITableViewCell() }
        cell.setUpCell(model)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("indexPath.row => ", indexPath.row)
//        print("displayCount => ", displayCount)
//        print("pageIndex => ", pageIndex)
//        print("")
        
        if let totalRecordCount = model?.totalRecordCount, let recordsPerPage = model?.recordsPerPage, let currentPageNo = model?.currentPageNo, let totalPageCount = model?.totalPageCount {
            if sizeIndex * 30 == indexPath.row {
                self.sizeIndex += 1
                
                viewModel.scrapFeed(pageIndex: 0, size: sizeIndex * 30)
                viewModel.didFinishFetch = {
                    self.model = self.viewModel.feedSelectResponse
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = model?.content {
            self.delegate?.pushScreen(FeedDetailViewController(), model[indexPath.row])
        }
    }
    
}

