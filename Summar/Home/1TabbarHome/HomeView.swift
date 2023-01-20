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
    
    var displayCount : Int = 0
    var pageIndex : Int = 1
    
    var model : FeedSelectResponse? {
        didSet {
            smLog("\n \(self.model) \n")
            
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
    }
    
    func selectFeed() {
        let viewModel = HomeViewModel(0, 30)
        viewModel.selectFeed()
        viewModel.didFinishFetch = {
            self.model = viewModel.feedSelectResponse
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
            
            
            if let model = model?.content {
                setProfileImage(cell.profileImg, model[indexPath.row - 1].user?.profileImageUrl)
                cell.nickName.text = model[indexPath.row - 1].user?.userNickname
                cell.major.text = model[indexPath.row - 1].user?.major2
                cell.contentsLabel.text = model[indexPath.row - 1].contents
                cell.feedImages = model[indexPath.row - 1].feedImages
                
                helper.lineSpacing(cell.contentsLabel, 5)
            }
            
            
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: bannerCellReuseIdentifier, for: indexPath) as! BannerTableViewCell
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func setProfileImage(_ imageView: UIImageView,_ urlString: String?) {
        guard let urlString = urlString else {return}
        let url = URL(string: urlString)
        //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
        //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(
                  with: url,
                  placeholder: nil,
                  options: [.transition(.fade(1.2))],
                  completionHandler: nil
                )
            }
        }
    }
    
}
