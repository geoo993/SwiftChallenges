//
//  PlaceListController.swift
//  DemoTest
//
//  Created by Abhisek on 6/9/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import UIKit

class AreaListController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = AreaListViewModel(dataFetcher: AreaDataFetcher())

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        headerLabel.text = viewModel.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AreaTableCell
        let cellDataModel = viewModel.tableCellDataModelForIndexPath(indexPath)
        cell.configureCell(model: cellDataModel)
        return cell
    }
    
}

