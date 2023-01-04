//
//  PreferencesView.swift
//  Summar
//
//  Created by mac on 2023/01/04.
//

import Foundation
import UIKit

protocol PopDelegate : AnyObject {
    func popScreen()
}

class PreferencesView: UIView{
    weak var delegate : PopDelegate?
    
    let cellReuseIdentifier = "PreferencesTableViewCell"
    let preferencesArray = ["로그아웃", "프로필 편집", "푸시 알림", "공지사항", "자주 묻는 질문"]
    
    let view1 : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleLabel : UILabel = {
        let title = UILabel()
        title.text = "환경 설정"
        title.font = .boldSystemFont(ofSize: 20)
        title.textColor = UIColor.summarColor1
        title.sizeToFit()
        return title
    }()
    
    let arrowBackWard : UIButton = {
        let arrowBackWard = UIButton()
        arrowBackWard.setImage(UIImage(systemName: "arrow.backward"), for: .normal) // ios 14.0
        arrowBackWard.tintColor = .black
        arrowBackWard.imageView?.contentMode = .scaleToFill
//        xmark.imageEdgeInsets = UIEdgeInsets(top: 32, left: 33, bottom: 33, right: 33)
        arrowBackWard.addTarget(self, action: #selector(topBtnAction(_:)), for: .touchUpInside)
        arrowBackWard.tag = 1
        return arrowBackWard
    }()
    
    lazy var tableView : UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(PreferencesTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#file , #function)
        
        _ = [view1, tableView].map {
            addSubview($0)
            $0.layer.borderWidth = 1
        }
        
        _ = [titleLabel, arrowBackWard].map {
            view1.addSubview($0)
            $0.layer.borderWidth = 1
        }
        
        view1.snp.makeConstraints{(make) in
//            make.left.equalTo(20)
//            make.top.equalTo(10)
//            make.right.equalTo(-20)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints{(make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        arrowBackWard.snp.makeConstraints{(make) in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.left.equalTo(20)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints{(make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view1.snp.bottom)
        }
        
    }
    
    @objc func topBtnAction(_ sender: Any){
//        print(sender)
        self.delegate?.popScreen()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PreferencesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preferencesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PreferencesTableViewCell
        cell.label.text = preferencesArray[indexPath.row]
        return cell
    }
    
}
