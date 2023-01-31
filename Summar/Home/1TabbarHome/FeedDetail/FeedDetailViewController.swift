//
//  FeedDetailViewController.swift
//  Summar
//
//  Created by ukBook on 2023/01/22.
//

import Foundation
import UIKit

class FeedDetailViewController: UIViewController {
    static let shared = FeedDetailViewController()
    let viewModel = FeedDetailViewModel()
    let feedView = FeedDetailVeiw()
    let helper = Helper()
    
    var userSeq: Int?
    
    var feedInfo : FeedInfo? {
        didSet {
            feedView.feedInfo = feedInfo
        }
    }
    
    override func viewDidLoad() {
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        feedView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    
    /// UI 초기설정
    func configureUI() {
        // MARK: - SafeArea or View BackGroundColor Set
        
        // MARK: - NavigationBar
        
        let leftBarBtn = self.navigationItem.makeSFSymbolButton(self, action: #selector(popView), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        let rightBarBtn1 = self.navigationItem.makeSFSymbolButtonWidth30(self, action: #selector(share), uiImage: UIImage(named: "share")!, tintColor: .black)
        let rightBarBtn2 = self.navigationItem.makeSFSymbolButtonWidth30(self, action: #selector(kebabMenu), uiImage: UIImage(named: "kebabMenu")!, tintColor: .black)
        
        self.navigationItem.leftBarButtonItem = leftBarBtn
        self.navigationItem.rightBarButtonItems = [rightBarBtn2, rightBarBtn1]
        // MARK: - addView
        self.view.addSubview(feedView)
        feedView.snp.makeConstraints{
            $0.right.left.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func popView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func share() {
        smLog("")
    }
    
    @objc func kebabMenu() {
        if let value = UserDefaults.standard.dictionary(forKey: "UserInfo"){
            guard let userSeq = value["userSeq"] else {return}
            
            if userSeq as? Int == feedInfo?.user?.userSeq { // 자신 피드
                smLog("자기 피드")
                helper.showAlertAction(vc: self, message1: "수정하기", message2: "삭제하기") { handler in
                    switch handler {
                    case "수정하기":
                        print("게시글 수정 로직")
                    case "삭제하기":
                        print("삭제")
                        self.helper.showAlertActionYN(vc: self, title: "알림", message: "정말로 해당 게시글을 삭제하시겠습니까?") { handler in
                            guard let handler = handler else {
                                print("취소")
                                return
                            }
                            // 게시글 삭제 로직
                            print("게시글 삭제 로직")
                        }
                    default:
                        break
                    }
                }
            }else {
                smLog("자기 피드아님")
                helper.showAlertAction(vc: self, message: "신고하기") { handler in
                    switch handler {
                    case "신고하기":
                        print("신고하기")
                    default:
                        break
                    }
                }
            }
        }
    }
}
