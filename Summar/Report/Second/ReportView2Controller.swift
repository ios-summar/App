//
//  ReportView2Controller.swift
//  Summar
//
//  Created by plsystems on 2023/02/09.
//

import Foundation
import UIKit

final class ReportView2Controller: UIViewController, ViewAttributes, UpdateNavigationBar{
    let helper = Helper.shared
    let fontManager = FontManager.shared
    let viewModel = ReportViewModel()
    let reportView = ReportView2()
    
    var param : Dictionary<String, Any> = [:]
    
    var reportReason: String = ""
    var myUserSeq: Int = getMyUserSeq()
    var opponsentUserSeq: Int?
    var feedSeq: Int?
    
    lazy var lbNavTitle : UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        title.text = "신고하기"
        title.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        smLog("\(param)")
        reportView.delegate = self
        
        setUI()
        setAttributes()
    }
    
    func setUI(){
        
        // MARK: - NavigationBar
        self.navigationItem.titleView = lbNavTitle
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(popScreen), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        self.navigationItem.rightBarButtonItem = self.navigationItem.makeSFSymbolButtonLabel(self, action: #selector(sendReport), title: "보내기", tintColor: UIColor.magnifyingGlassColor)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: self.fontManager.getFont(Font.SemiBold.rawValue).medium15Font,
                    NSAttributedString.Key.foregroundColor: UIColor.magnifyingGlassColor],
                for: .normal)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        reportView.reportReason = self.reportReason
        reportView.param = self.param
        self.view.addSubview(reportView)
    }
    
    func setAttributes() {
        
        reportView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func updateNavigationBar() {
        if reportView.sendBool {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc func popScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendReport(){
        smLog("")
        
        let reportType = reportView.report1TextField.text
        let reportContent = reportView.view2TextView.text
        
        param["reportType"] = reportType
        param["reportContent"] = reportContent
        
        viewModel.report(param)
        viewModel.didFinishFetch = {
            toast("신고완료, 관리자가 검토후 조치하겠습니다.")
            
            let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
            self.navigationController?.popToViewController(controller!, animated: true)
        }
    }
}
