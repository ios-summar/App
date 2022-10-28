//
//  StartController.swift
//  Summar
//
//  Created by ukBook on 2022/10/16.
//

import UIKit
import SnapKit

class StartController: UIViewController, Delegate {
    
    let startView = StartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        startView.delegate = self
        
        self.view.addSubview(startView)
        
        // layout
        startView.snp.makeConstraints{(make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    func moveScreen(storyboard: String, controller: String) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: controller)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
