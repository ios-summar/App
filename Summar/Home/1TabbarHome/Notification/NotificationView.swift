//
//  NotificationView.swift
//  Summar
//
//  Created by ukBook on 2023/02/19.
//

import Foundation
import UIKit

final class NotificationView: UIView, ViewAttributes {
    weak var delegate: PushDelegate?
    let viewModel = NotificationViewModel()
    
    var model: NotificationModel? {
        didSet {
            smLog("\(model)")
        }
    }
    lazy var tableView : UITableView = {
        let view = UITableView()
        view.register(NotificationTableViewCell.self, forCellReuseIdentifier: "NotificationTableViewCell")
        view.separatorStyle = .singleLine
        view.cellLayoutMarginsFollowReadableWidth = false
        view.separatorInset.left = 0
        view.separatorColor = .gray
        view.backgroundColor = .white
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getNotiList), for: .valueChanged)
        view.refreshControl = refreshControl
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        setUI()
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        addSubview(tableView)
    }
    
    func setAttributes() {
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func getNotiList() {
        viewModel.getNotiList()
        viewModel.didFinishFetch = {
            self.model = self.viewModel.model
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension NotificationView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model?.result else {return 0}
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model?.result[indexPath.row] else {return UITableViewCell()}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.setUpCell(model)
        
        return cell
    }
}
