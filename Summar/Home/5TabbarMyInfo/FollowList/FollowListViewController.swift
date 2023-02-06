//
//  FollowListViewController.swift
//  Summar
//
//  Created by mac on 2023/01/04.
//

import Foundation
import UIKit
import SnapKit

final class FollowListViewController: UIViewController, PushDelegate, ViewAttributes{
    func pushScreen(_ VC: UIViewController, _ any: Any?) {
        let userSeq = any as? Int
        
        ProfileViewController.shared.userSeq = userSeq
        self.navigationController?.pushViewController(ProfileViewController.shared, animated: true)
    }
    
    static let shared = FollowListViewController()
    let followListView = FollowListView()

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
        followListView.delegate = self
        
        setUI()
        setAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userSeq = userSeq else {return}
        followListView.userSeq = userSeq
        followListView.getFollowerList(userSeq)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        followListView.touchLeft()
    }
    
    func setUI() {
        smLog("\(userSeq)")
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(topBtnAction(_:)), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        
        self.view.addSubview(followListView)
    }
    
    func setAttributes() {
        followListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func topBtnAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
