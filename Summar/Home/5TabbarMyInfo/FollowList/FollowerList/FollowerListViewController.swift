//
//  FollowListViewController.swift
//  Summar
//
//  Created by mac on 2023/01/04.
//

import Foundation
import UIKit
import SnapKit

final class FollowerListViewController: UIViewController, PushDelegate, ViewAttributes {
    func pushScreen(_ VC: UIViewController, _ any: Any?) {
        let VC = ProfileViewController()
        let userSeq = any as? Int
        
        VC.userSeq = userSeq
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    let followerListView = FollowerListView()

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
        followerListView.delegate = self
        
        setUI()
        setAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userSeq = userSeq else {return}
        let myFollow = userSeq == getMyUserSeq()  // true => 내 팔로우 리스트, false => 내 팔로우 리스트 아님
        
        followerListView.userSeq = userSeq
        followerListView.getFollowerList(userSeq, myFollow)
    }
    
    func setUI() {
        smLog("\(userSeq)")
        self.view.addSubview(followerListView)
    }
    
    func setAttributes() {
        followerListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func topBtnAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
