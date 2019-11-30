//
//  WineTableViewController.swift
//  WineShop
//
//  Created by Maxime Magné on 18/11/2019.
//  Copyright © 2019 Maxime Magné. All rights reserved.
//

import UIKit
import CoreData

class WineTableViewController: UITableViewController {
    
    var dataSource = WineDataSource()
    
    var wines = [WineModel]()

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
        print("Goes here")
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
        
        cell.WineImage.load(url: URL(string: "http://192.168.0.201:8080/image/\(currentWine.image)")!)
        cell.WineName.text = currentWine.subtype.label
        cell.WineDescription.text = currentWine.subtype.description
        cell.WinePrice.text = String(currentWine.price) + "€"
        return cell
    }
}
