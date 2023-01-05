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
    
//    let textField : UITextField = {
//        let textField = UITextField()
//        textField.borderStyle = .roundedRect
//        textField.backgroundColor = UIColor.searchGray
//        textField.textColor = .black
//        textField.placeholder = "닉네임으로 검색"
//        textField.addLeftPadding()
//        textField.addTarget(self, action: #selector(search), for: .editingChanged)
//        textField.attributedPlaceholder = NSAttributedString(string: "닉네임으로 검색", attributes: [NSAttributedString.Key.foregroundColor : UIColor.imageViewColor])
//        return textField
//    }()
//
//    let xMark : UIButton = {
//        let xMark = UIButton()
//        xMark.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
//        xMark.tintColor = .black
//        xMark.imageView?.contentMode = .scaleToFill
//        xMark.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 33, right: 35)
//        xMark.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
//        xMark.layer.borderWidth = 1
//        xMark.tag = 1
//        xMark.alpha = 0.0
//        return xMark
//    }()
    
    let view : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.searchGray
        return view
    }()
    
    
    let searchImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill.questionmark")
        imageView.tintColor = UIColor.imageViewColor
        return imageView
    }()
    
    lazy var label : UILabel = {
        let label = UILabel()
        label.text = "닉네임을 검색해 사용자를 찾아보세요"
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.imageViewColor
        label.sizeToFit()
        self.helper.lineSpacing(label, 10)
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
//    var searchUserInfo : [SearchUserInfo]? = nil
//
//    var currentPageNo: Int? = nil
//    var firstPage: Bool? = nil
//    var lastPage: Bool? = nil
//    var recordsPerPage: Int? = nil
//    var totalPageCount: Int? = nil
//    var totalRecordCount: Int? = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(view)
        
        _ = [searchImageView, label].map {
            view.addSubview($0)
        }
        
        view.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.bottom.right.equalTo(0)
        }
        
        searchImageView.snp.makeConstraints{(make) in
            make.top.equalTo(50)
            make.width.equalTo(100)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints{(make) in
            make.top.equalTo(searchImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
    
    
    @objc func topBtnAction(_ sender: Any) {
        let tagValue = (sender as? UIButton)?.tag
        
        switch tagValue {
        case 1: // Delete Action
            print("Delete Action")
            isEmpty(true)
//            textField.text = ""
        case 2: // DirectMessage Event
            print("DirectMessage")
        default:
            print("default")
        }
    }
    
    @objc func search(){
//        if (textField.text?.isEmpty)! {
//            isEmpty(true)
//        }else {
//            let nickname = textField.text!
//            isEmpty(false)
//
//            //Network Call
//            let viewModel = SearchViewModel(nickname, 0, 30)
//            viewModel.searchNickname()
//
//            viewModel.didFinishFetch = {
//                self.empty = viewModel.empty
//
//                if self.empty! { //검색결과 없음
//                    print("검색결과 없음")
//                    self.searchTableView.removeFromSuperview()
//
//                    self.label.text = "검색결과가 없습니다.\n닉네임을 정확하게 입력해주세요."
//                    self.searchImageView.image = UIImage(systemName: "person.fill.xmark")
//                }else {
//                    print("검색결과 있음")
//
//                    self.model = viewModel.searchUserList
//
//                    self.searchTableView.dataSource = self
//                    self.searchTableView.delegate = self
//
//                    self.view.addSubview(self.searchTableView)
//                    self.searchTableView.snp.makeConstraints{(make) in
//                        make.top.equalTo(self.view.snp.top)
//                        make.left.right.bottom.equalToSuperview()
//                    }
//                    self.searchTableView.reloadData()
//                }
//            }
//        }
    }
    
    // MARK: - TextField Empty 유무로 UI SetUp
    func isEmpty(_ TF : Bool){
        if TF { // textField가 비어있지 않음
//            xMark.alpha = 0.0
            
            _ = [searchImageView, label].map {
                view.addSubview($0)
            }
            
            searchImageView.snp.makeConstraints{(make) in
                make.top.equalTo(50)
                make.width.equalTo(100)
                make.height.equalTo(80)
                make.centerX.equalToSuperview()
            }
            
            label.snp.makeConstraints{(make) in
                make.top.equalTo(searchImageView.snp.bottom).offset(30)
                make.centerX.equalToSuperview()
            }
            
            label.text = "닉네임을 검색해 사용자를 찾아보세요"
            label.textColor = UIColor.imageViewColor
            searchImageView.image = UIImage(systemName: "person.fill.questionmark")
            searchImageView.tintColor = UIColor.imageViewColor
            
            
            searchTableView.removeFromSuperview()
        }else{
//            xMark.alpha = 1.0
//            _ = [searchImageView, label].map {
//                $0.removeFromSuperview()
//            }
            
            //TEST
//            view.addSubview(searchTableView)
//
//            searchTableView.snp.makeConstraints{(make) in
//                make.top.equalTo(view.snp.top)
//                make.left.right.bottom.equalToSuperview()
//            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SearchView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
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
                cell.profileImg.image = UIImage(systemName: "person.fill")
            }
            
            cell.nickName.text = searchUserInfo[indexPath.row].userNickname
            
            if searchUserInfo[indexPath.row].introduce != nil {
                cell.major.text = searchUserInfo[indexPath.row].introduce
            }else {
                cell.major.text = searchUserInfo[indexPath.row].major2
            }
            
            cell.followLabel.text = "팔로워 \(searchUserInfo[indexPath.row].follower!)"
            return cell
        }else {
            return UITableViewCell()
        }
    }
}
