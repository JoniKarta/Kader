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
    var fbGroupService: FBGroupService!
    var fbUserService: FBUserService!
    var userSelectedGroupList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fbGroupService = FBGroupService(callback: self)
        fbUserService = FBUserService(callback: self)
        fbGroupService.getAllGroups()
        fbUserService.onUserGroupsChangedListener(userEmail: user.userEmail)
    }
   
    // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    // Handle the cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellReusableGroup, for: indexPath)
        cell.textLabel?.text = groupList[indexPath.row].groupName
        if userSelectedGroupList.contains(groupList[indexPath.row].groupName) {
              cell.accessoryType = .checkmark
        }
        return cell
    }
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           // Handle the state of the current selected todo item
        if !self.userSelectedGroupList.contains(groupList[indexPath.row].groupName) {
            fbGroupService.appendGroupToUser(user: user, group: groupList[indexPath.row])
        }else {
            
        }
           // Handle the problem of selection a row and it flashes
           tableView.deselectRow(at: indexPath, animated: true)
           
       }}

extension SearchGroupTableViewController : GroupCallback {
    func onFinish(group: [Group]) {
        if !group.isEmpty {
            self.groupList = group
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchGroupTableViewController: UserCallback {
    func onFinish(user: User) {
        self.userSelectedGroupList = []
        self.userSelectedGroupList = user.selectedGroupsList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}
