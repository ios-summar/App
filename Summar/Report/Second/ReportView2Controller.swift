//
//  ReportView2Controller.swift
//  Summar
//
//  Created by plsystems on 2023/02/09.
//

import Foundation
import UIKit

final class ReportView2Controller: UIViewController, ViewAttributes, UpdateNavigationBar{
    let helper = Helper()
    let reportView = ReportView2()
    
    var param : Dictionary<String, Any> = [:]
    
    var reportReason: String = ""
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
        setUI()
        setAttributes()
    }
    
    func setUI(){
        
        // MARK: - NavigationBar
        self.navigationItem.titleView = lbNavTitle
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(popScreen), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButtonLabel(self, action: #selector(sendReport), title: "보내기", tintColor: UIColor.magnifyingGlassColor)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
                    NSAttributedString.Key.font: FontManager.getFont(Font.SemiBold.rawValue).medium15Font,
                    NSAttributedString.Key.foregroundColor: UIColor.magnifyingGlassColor],
                for: .normal)
        
        reportView.reportReason = self.reportReason
        reportView.opponsentUserSeq = self.opponsentUserSeq
        reportView.feedSeq = self.feedSeq
        self.view.addSubview(reportView)
    }
    
    func setAttributes() {
        
        reportView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func updateNavigationBar() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @objc func popScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendReport(){
        smLog("")
    }
}
