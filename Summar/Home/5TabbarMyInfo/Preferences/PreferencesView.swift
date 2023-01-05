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
        
        _ = [tableView].map {
            addSubview($0)
            $0.layer.borderWidth = 1
        }
        
        tableView.snp.makeConstraints{(make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(0)
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
