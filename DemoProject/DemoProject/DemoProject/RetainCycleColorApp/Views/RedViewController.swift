//
//  RedViewController.swift
//  DemoProject
//
//  Created by GEORGE QUENTIN on 06/05/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import UIKit

class Service {
    var redController: RedViewController?
}

class RedViewController: UIViewController {
    let service = Service()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.red
        service.redController = self
    }
    
    deinit {
        print("OS reclaiming memory for RedController")
    }
}
