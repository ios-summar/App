//
//  NotificationView.swift
//  Summar
//
//  Created by ukBook on 2023/02/19.
//

import Foundation
import UIKit

final class NotificationView: UIView, ViewAttributes, NotificationButtonDelegate {
    weak var delegate: PushDelegate?
    let myInfoViewModel = MyInfoViewModel(nil, nil)
    let notiViewModel = NotificationViewModel()
    let fontManager = FontManager.shared
    
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
        UILabel.text = "알림이 없습니다"
        return UILabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        backgroundColor = .white
        
        addSubview(tableView)
        addSubview(view)
        
        view.addSubview(noImage)
        view.addSubview(noLabel)
    }
    
    func setAttributes() {
        
        tableView.snp.makeConstraints {
            
            $0.edges.equalToSuperview()
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
    
    @objc func getNotiList() {
        notiViewModel.getNotiList()
        notiViewModel.didFinishFetch = {
            self.model = self.notiViewModel.model
            guard let count = self.model?.result.count else{ toast("서버 오류, 잠시후 다시 시도해주세요."); return }
            
            if count > 0 {
                
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
            }else {
                
                self.tableView.alpha = 0.0
                self.view.alpha = 1.0
            }
            
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
        cell.delegate = self
        cell.setUpCell(model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = model?.result[indexPath.row], let notiType = model.notificationType, let otherUserSeq = model.otherUserSeq else {return}
        
        switch notiType {
        case "댓글":
            
//            self.delegate?.pushScreen(ProfileViewController(), otherUserSeq)
            break
        case "좋아요", "팔로우":
            
            self.delegate?.pushScreen(ProfileViewController(), otherUserSeq)
            break
        default:
            break
        }
    }
    
    /// 팔로우 / 팔로우 취소 버튼 Event
    func btnAction(_ param: Dictionary<String, Int>, _ handler: String, completion: @escaping () -> ()) {
        
        myInfoViewModel.followAction(param, handler)
        myInfoViewModel.didFinishFollowFetch = {
            completion()
        }
    }
}
