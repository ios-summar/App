//
//  FollowingListViewController.swift
//  Summar
//
//  Created by mac on 2023/01/04.
//

import Foundation
import UIKit
import SnapKit

final class FollowingListViewController: UIViewController, PushDelegate, ViewAttributes{
    func pushScreen(_ VC: UIViewController, _ any: Any?) {
        let userSeq = any as? Int
        
        ProfileViewController.shared.userSeq = userSeq
        self.navigationController?.pushViewController(ProfileViewController.shared, animated: true)
    }
    
    static let shared = FollowingListViewController()
    let followingListView = FollowingListView()

    var userSeq: Int?
    let arrowBackWard : UIButton = {
        let arrowBackWard = UIButton()
        arrowBackWard.setImage(UIImage(systemName: "arrow.backward"), for: .normal) // ios 14.0
        arrowBackWard.tintColor = .black
        arrowBackWard.imageView?.contentMode = .scaleToFill
        arrowBackWard.tag = 1
        return arrowBackWard
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followingListView.delegate = self
        
        setUI()
        setAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userSeq = userSeq else {return}
        followingListView.userSeq = userSeq
        followingListView.getFollowingList(userSeq)
    }
    
    func setUI() {
        smLog("\(userSeq)")
        self.view.addSubview(followingListView)
    }
    
    func setAttributes() {
        followingListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func topBtnAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
