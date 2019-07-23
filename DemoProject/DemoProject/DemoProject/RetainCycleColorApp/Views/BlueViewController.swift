//
//  ViewController.swift
//  DemoProject
//
//  Created by GEORGE QUENTIN on 06/05/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import UIKit

class BlueViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show red", style: .plain, target: self, action: #selector(handleTap))
    }

    @objc func handleTap() {
        navigationController?.pushViewController(RedViewController(), animated: true)
    }
}
