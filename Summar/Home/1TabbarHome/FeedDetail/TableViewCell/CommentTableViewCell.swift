//
//  CommentTableViewCell.swift
//  Summar
//
//  Created by ukBook on 2023/02/10.
//

import Foundation
import UIKit

final class CommentTableViewCell: UITableViewCell, ViewAttributes, PushDelegate, TableViewReload, ReplyDelegate{
    weak var delegate: PushDelegate?
    func pushScreen(_ VC: UIViewController, _ any: Any?) {
        if VC.isKind(of: ProfileViewController.self) {
            let VC = ProfileViewController()
            let userSeq = any as! Int
            
            self.delegate?.pushScreen(VC, userSeq)
        }else if VC.isKind(of: ReportViewController.self) {
            let VC = ReportViewController()
            let param = any as! Dictionary<String, Any>
            
            self.delegate?.pushScreen(VC, param)
        }
    }
    
    weak var reloadDelegate: TableViewReload?
    func tableViewReload() {
        self.reloadDelegate?.tableViewReload()
    }
    
    weak var replyDelegate: ReplyDelegate?
    func reply(parentCommentSeq: Int, userNickname: String, activated: Bool) {
        self.replyDelegate?.reply(parentCommentSeq: parentCommentSeq, userNickname: userNickname, activated: activated)
    }
    
    var comment: Comment? {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.reloadData()
            
//            tableView.estimatedRowHeight = 110
//            tableView.rowHeight = UITableView.automaticDimension
            
            self.layoutIfNeeded()
        }
    }
    
    let tableView: UITableView = {
        let view = ContentSizedTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        
        // 테이블뷰 왼쪽 마진 없애기
        view.separatorStyle = .none
        view.register(CommentParentTableViewCell.self, forCellReuseIdentifier: "CommentParentTableViewCell")
        view.register(CommentChildTableViewCell.self, forCellReuseIdentifier: "CommentChildTableViewCell")
        
        view.layer.borderWidth = 1
        return view
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

//        tableView.beginUpdates()
//        tableView.reloadData()
//        tableView.endUpdates()
        
//        print(tableView.intrinsicContentSize.height)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.contentView.addSubview(tableView)
    }
    
    func setAttributes() {
        tableView.snp.makeConstraints {
            
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension CommentTableViewCell: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let comment = comment, let childCommentsCount = comment.childCommentsCount else {return 0}
        
        return 1 + childCommentsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let comment = comment else {return UITableViewCell()}
            let cellP = tableView.dequeueReusableCell(withIdentifier: "CommentParentTableViewCell", for: indexPath) as! CommentParentTableViewCell
            cellP.delegate = self
            cellP.reloadDelegae = self
            cellP.replyDelegate = self
//            cellP.layer.borderColor = UIColor.magenta.cgColor
//            cellP.layer.borderWidth = 1
            
            cellP.setUpCell(comment)
            return cellP
        default:
            guard let childComment = comment?.childComments?[indexPath.row - 1] else {return UITableViewCell()}
            let cellC = tableView.dequeueReusableCell(withIdentifier: "CommentChildTableViewCell", for: indexPath) as! CommentChildTableViewCell
            cellC.delegate = self
            cellC.reloadDelegae = self
//            cellC.layer.borderColor = UIColor.red.cgColor
//            cellC.layer.borderWidth = 1
            
            cellC.setUpCell(childComment)
            return cellC
        }
    }
}
