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
    var model : SearchUserList? = nil
    
    
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
        view.backgroundColor = .white
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return view
    }()
    
    var empty : Bool? = nil
    var searchUserList : SearchUserList? = nil
    
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
                    self.view.backgroundColor = .white
                    self.searchImageView.image = UIImage(named: "NoSearch")
                }else {
                    print("검색결과 있음")
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
        return 136
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let totalRecordCount = model?.totalRecordCount, let recordsPerPage = model?.recordsPerPage, let currentPageNo = model?.currentPageNo {
            if totalRecordCount < 30 {
                return totalRecordCount
            }else {
                return recordsPerPage * currentPageNo
            }
        }else {
            return 0
        }
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("model.content \(model?.content)")
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SearchTableViewCell
        
        if let searchUserInfo = model?.content {
            
            if searchUserInfo[indexPath.row].profileImageUrl != nil {
                cell.profileImg.image = UIImage(systemName: "person")//profileImageUrl
            }else {
                cell.profileImg.image = UIImage(named: "NonProfile")
            }
            
            cell.nickName.text = searchUserInfo[indexPath.row].userNickname
            
//            if searchUserInfo[indexPath.row].introduce != nil {
                cell.introduceLabel.text = "프론트 백앤드 클라우스 스토리지 등 다양한 분야의 개발 경험을 보유하고 있습니다."
//                cell.major.text = searchUserInfo[indexPath.row].introduce
//            }else {
//                
//            }
            cell.major.text = searchUserInfo[indexPath.row].major2
            
            cell.followLabel.text = "팔로워 \(searchUserInfo[indexPath.row].follower!.commaRepresentation) · 팔로잉 \(searchUserInfo[indexPath.row].following!.commaRepresentation)"
            return cell
        }else {
            return UITableViewCell()
        }
    }
}
