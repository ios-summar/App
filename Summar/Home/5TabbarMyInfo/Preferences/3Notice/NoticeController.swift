//
//  NoticeController.swift
//  Summar
//
//  Created by ukBook on 2023/01/14.
//

import Foundation
import UIKit

final class NoticeController: UIViewController {
    let fontManager = FontManager.shared
    let noticeView = NoticeView()
    let viewModel = NoticeViewModel()
    
    lazy var titleLabel : UILabel = {
        let title = UILabel()
        title.text = "공지사항"
        title.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(topBtnAction(_:)), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        
        self.view.addSubview(noticeView)
        noticeView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            $0.left.right.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noticeView.getNotice()
    }
    
    @objc func topBtnAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
