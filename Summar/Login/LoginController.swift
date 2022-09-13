//
//  ViewController.swift
//  Summar
//
//  Created by ukBook on 2022/09/08.
//

import UIKit

class ViewController: UIViewController {
    
    let loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(loginView)
        
        // layout
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        loginView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        loginView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        loginView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }

}

