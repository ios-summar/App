//
//  ReportViewController.swift
//  Summar
//
//  Created by plsystems on 2023/02/09.
//

import Foundation
import UIKit

final class ReportViewController: UIViewController, ViewAttributes, PushDelegate{
    func pushScreen(_ VC: UIViewController, _ any: Any?) {
        let VC = VC as! ReportView2Controller
        
//        VC.opponsentUserSeq = self.opponsentUserSeq
//        VC.feedSeq = self.feedSeq
        VC.reportReason = any as! String
        VC.param = self.param
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    let helper = Helper()
    let reportView = ReportView()
    
    var param : Dictionary<String, Any> = [:]
    
    var myUserSeq: Int = getMyUserSeq()
    var opponsentUserSeq: Int?
    var feedSeq: Int?
    
    let lbNavTitle : UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        title.text = "신고하기"
        title.font = FontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportView.delegate = self
        
        setUI()
        setAttributes()
    }
    
    func setUI(){
        
        // MARK: - NavigationBar
        self.navigationItem.titleView = lbNavTitle
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(popScreen), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        
        self.view.addSubview(reportView)
    }
    
    func setAttributes() {
        
        reportView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    @objc func popScreen() {
        self.navigationController?.popViewController(animated: true)
    }
}
