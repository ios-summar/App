//
//  TitleViewSearch.swift
//  Summar
//
//  Created by ukBook on 2022/12/27.
//

import Foundation
import UIKit
import SnapKit


class SearchView: UIView{
    static let shared = SearchView()
    
    let cellReuseIdentifier = "SearchTableViewCell"
    let helper = Helper()
    var model : SearchUserList? = nil {
        didSet {
            //            smLog("model.count")
            //            print(model?.content?.count)
        }
    }
    
    var searchUserInfoList : [SearchUserInfo]? {
        didSet {
            print("searchUserList.count \(searchUserInfoList?.count)")
        }
    }
    
    
    let view : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let labelView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let searchImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "WaitSearch")
        imageView.tintColor = UIColor.imageViewColor
        return imageView
    }()
    
    lazy var searchCountLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor.magnifyingGlassColor
        label.sizeToFit()
        return label
    }()
    
    lazy var searchDescriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "검색결과"
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.sizeToFit()
        return label
    }()
    
    lazy var searchTableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.searchGray
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        view.separatorStyle = .none
        return view
    }()
    
    var nickname : String = ""
    var displayCount : Int = 0
    var pageIndex : Int = 1
    
    var empty : Bool? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(view)
        _ = [searchImageView].map {
            view.addSubview($0)
            //            view.layer.borderWidth = 1
            //            $0.layer.borderWidth = 1
        }
        
        view.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.bottom.right.equalTo(0)
        }
        
        searchImageView.snp.makeConstraints{(make) in
            make.top.equalTo(self.view.snp.top).offset(50)
            make.width.equalTo(215)
            make.height.equalTo(195)
            make.centerX.equalToSuperview()
        }
    }
    
    func search(_ nickname: String){
        if (nickname.isEmpty) {
            isEmpty(true, nil)
        }else {
            self.nickname = nickname
            isEmpty(false, nickname)
        }
    }
    
    // MARK: - TextField Empty 유무로 UI SetUp
    func isEmpty(_ TF : Bool,_ nickname: String?){
        if TF { // textField가 비어있음
            
            _ = [searchImageView].map {
                view.addSubview($0)
                view.backgroundColor = .white
            }
            
            self.searchImageView.snp.updateConstraints{(make) in
                make.width.equalTo(215)
            }
            searchImageView.image = UIImage(named: "WaitSearch")
            searchImageView.tintColor = UIColor.imageViewColor
            
            searchTableView.removeFromSuperview()
            labelView.removeFromSuperview()
        }else{
            //Network Call
            let viewModel = SearchViewModel(nickname, 0, 30)
            viewModel.searchNickname()
            
            viewModel.didFinishFetch = {
                self.empty = viewModel.empty
                
                if self.empty! { //검색결과 없음
                    print("검색결과 없음")
                    self.searchTableView.removeFromSuperview()
                    self.labelView.removeFromSuperview()
                    
                    self.searchImageView.snp.updateConstraints{(make) in
                        make.width.equalTo(231)
                    }
                    self.searchImageView.image = UIImage(named: "NoSearch")
                }else {
                    print("검색결과 있음")
                    // 재검색을 위한 초기화
                    self.displayCount = 0
                    self.pageIndex = 1
                    
                    self.view.backgroundColor = UIColor.searchGray
                    
                    self.model = viewModel.searchUserList
                    guard let totalRecordCount = self.model?.totalRecordCount else{ return }
                    
                    self.searchCountLabel.text = "\(totalRecordCount)건"
                    // 검색결과 x건 set
                    self.addSubview(self.labelView)
                    _ = [self.searchCountLabel, self.searchDescriptionLabel].map{
                        self.labelView.addSubview($0)
                    }
                    
                    self.labelView.snp.makeConstraints{(make) in
                        make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(2)
                        make.left.right.equalToSuperview()
                        make.height.equalTo(35)
                    }
                    self.searchDescriptionLabel.snp.makeConstraints{(make) in
                        make.centerY.equalToSuperview()
                        make.left.equalTo(22)
                    }
                    self.searchCountLabel.snp.makeConstraints{(make) in
                        make.centerY.equalToSuperview()
                        make.left.equalTo(self.searchDescriptionLabel.snp.right).offset(5)
                    }
                    
                    // 테이블 set
                    self.searchTableView.dataSource = self
                    self.searchTableView.delegate = self
                    
                    self.view.addSubview(self.searchTableView)
                    self.searchTableView.snp.makeConstraints{(make) in
                        make.top.equalTo(self.labelView.snp.bottom).offset(2)
                        make.left.right.bottom.equalToSuperview()
                    }
                    self.searchTableView.reloadData()
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SearchView: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let totalRecordCount = model?.totalRecordCount, let recordsPerPage = model?.recordsPerPage, let currentPageNo = model?.currentPageNo, let totalPageCount = model?.totalPageCount {
            if totalRecordCount < 30 { // 30개 미만일때는 총 건수만 return
                return totalRecordCount
            }else { // 30개 이상일때
                if currentPageNo != totalPageCount { // 총건수를 30으로 나눴을때 현재페이지 != 마지막페이지
                    displayCount = 30 * pageIndex
                    return displayCount // 30개씩 * 현재페이지 ex) 120건 노출시 30.. 60.. 90.. 120...
                }else { // 총건수를 30으로 나눴을때 현재페이지 == 마지막페이지
                    displayCount = (30 * (pageIndex - 1)) + (totalRecordCount % 30)
                    return displayCount // (30개씩 * 현재페이지) + 나머지(총 건수 % 30건)
                }
            }
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("indexPath.row => ", indexPath.row + 1)
        print("displayCount => ", displayCount)
        print("pageIndex => ", pageIndex)
        print("")
        
        if let totalRecordCount = model?.totalRecordCount, let recordsPerPage = model?.recordsPerPage, let currentPageNo = model?.currentPageNo, let totalPageCount = model?.totalPageCount {
            if pageIndex * 30 == indexPath.row + 1 {
                self.pageIndex += 1
                let viewModel = SearchViewModel(nickname, 0, (30 * pageIndex))
                viewModel.searchNickname()

                viewModel.didFinishFetch = {
                    self.model = viewModel.searchUserList
                    self.searchTableView.reloadData()
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("model.content \(model)")
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SearchTableViewCell
        
        if let searchUserInfo = model?.content {
            print("searchUserInfo.count => \(searchUserInfo.count)")
            if searchUserInfo[indexPath.row].profileImageUrl != nil {
                let url = URL(string: searchUserInfo[indexPath.row].profileImageUrl!)
                //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
                //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        //                    cell.imageView.image = UIImage(data: data!)
                        cell.profileImg.kf.indicatorType = .activity
                        cell.profileImg.kf.setImage(
                            with: url,
                            placeholder: nil,
                            options: [.transition(.fade(1.2))],
                            completionHandler: nil
                        )
                    }
                }
            }else {
                cell.profileImg.image = UIImage(named: "NonProfile")
            }
            
            cell.nickName.text = searchUserInfo[indexPath.row].userNickname
            
            if searchUserInfo[indexPath.row].introduce != nil {
                cell.introduceLabel.text = searchUserInfo[indexPath.row].introduce
            }else {
                cell.introduceLabel.text = ""
            }
            
            cell.major.text = searchUserInfo[indexPath.row].major2
            
            cell.followLabel.text = "팔로워 \(searchUserInfo[indexPath.row].follower!.commaRepresentation) · 팔로잉 \(searchUserInfo[indexPath.row].following!.commaRepresentation)"
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchUserInfo = model?.content {
            print(searchUserInfo[indexPath.row])
        }
    }
}
