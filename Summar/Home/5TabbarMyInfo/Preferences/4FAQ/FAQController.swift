//
//  FAQController.swift
//  Summar
//
//  Created by ukBook on 2023/01/15.
//

import Foundation
import UIKit

class FAQController: UIViewController {
    static let shared = FAQController()
    let faqView = FAQView()
    let viewModel = FAQViewModel()
    
    let titleLabel : UILabel = {
        let title = UILabel()
        title.text = "자주묻는질문"
        title.font = .boldSystemFont(ofSize: 20)
        title.textColor = UIColor.summarColor1
        title.sizeToFit()
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(topBtnAction(_:)), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
        
        self.view.addSubview(faqView)
        faqView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            $0.left.right.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        faqView.getNotice()
    }
    
    @objc func topBtnAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
