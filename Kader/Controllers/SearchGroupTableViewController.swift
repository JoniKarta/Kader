//
//  SearchGroupTableViewController.swift
//  Kader
//
//  Created by user165579 on 6/12/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit

class SearchGroupTableViewController: UITableViewController {
        
    var groupList = [Group]()
    var user: User!
    var fbGroupService: FirebaseFirestoreGroupService!
    var userGroupId = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fbGroupService = FirebaseFirestoreGroupService(vc: self, callback: self)
        fbGroupService.onUserGroupListChangeListener(user: user)
        print("Testingggggg")
    }
   
    // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    // Handle the cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellReusableGroup, for: indexPath)
        cell.textLabel?.text = groupList[indexPath.row].groupName
        if userGroupId.contains(groupList[indexPath.row].getUUID()) {
              cell.accessoryType = .checkmark
        }
        return cell
    }
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           // Handle the state of the current selected todo item
        if !self.userGroupId.contains(groupList[indexPath.row].getUUID()) {
            fbGroupService.appendGroupToUser(user: user, group: groupList[indexPath.row])
        }else {
            
        }
           // Handle the problem of selection a row and it flashes
           tableView.deselectRow(at: indexPath, animated: true)
           
       }
    
}

extension SearchGroupTableViewController : GroupCallback {
    func onFinish(user: User,group: [Group]) {
        print("on Finish gets called from SearchGroupTableViewController - GroupCallback")
        if !group.isEmpty {
            self.groupList = group
            self.userGroupId = []
            self.userGroupId = user.groupListId
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

