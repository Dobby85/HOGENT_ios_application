//
//  WineTableViewController.swift
//  WineShop
//
//  Created by Maxime Magné on 18/11/2019.
//  Copyright © 2019 Maxime Magné. All rights reserved.
//

import UIKit
import CoreData
import os.log

class WineTableViewController: UITableViewController {
    
    var dataSource = WineDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(fetchWines), for: .valueChanged)
        
        fetchWines()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func fetchWines () {
        dataSource.fetchWines()
    }
    
    func finishedLoadWines() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.getWines().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "WineTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WineTableViewCell else {
            fatalError("The dequeued cell is not an instance of WineTableViewCell")
        }

        let currentWine = dataSource.getWines()[indexPath.row]
        
        cell.WineImage.load(url: URL(string: "http://172.20.10.2:8080/image/\(currentWine.image)")!)
        cell.WineName.text = currentWine.subtype.label
        cell.WineDescription.text = currentWine.subtype.description
        cell.WinePrice.text = String(currentWine.price) + "€"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "ShowDetail":
            guard let wineDetailViewController = segue.destination as? WineDetailController else {
                fatalError("Unexpected destination \(segue.destination)")
            }
            guard let selectedWineCell = sender as? WineTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedWineCell) else {
                fatalError("The selected cell is not being displayed in the table")
            }

            let selectedWine = dataSource.getWines()[indexPath.row]
            wineDetailViewController.wine = selectedWine
        default:
            os_log("unknow identifier", log: OSLog.default, type: .debug)
        }
    }
}
