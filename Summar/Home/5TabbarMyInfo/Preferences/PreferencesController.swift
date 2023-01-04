//
//  PreferencesController.swift
//  Summar
//
//  Created by mac on 2023/01/04.
//

import Foundation
import UIKit

class PreferencesController: UIViewController, PopDelegate{
    func popScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    static let shared = PreferencesController()
    
    let preferencesView = PreferencesView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(preferencesView)
        self.view.backgroundColor = .white
        preferencesView.delegate = self
        
        preferencesView.snp.makeConstraints{(make) in
            make.edges.equalToSuperview()
        }
    }
}
