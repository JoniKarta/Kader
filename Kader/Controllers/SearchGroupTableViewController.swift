//
//  SearchGroupTableViewController.swift
//  Kader
//
//  Created by user165579 on 6/12/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit

class SearchGroupTableViewController: UITableViewController {
    
    var groupList = ["Test1","Test2","Test3"]
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    // Handle the cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellReusableGroup, for: indexPath)
        
        return cell
    }

    

}
