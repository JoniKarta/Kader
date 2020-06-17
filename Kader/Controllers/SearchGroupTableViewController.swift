//
//  SearchGroupTableViewController.swift
//  Kader
//
//  Created by user165579 on 6/12/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit
import SwipeCellKit

class SearchGroupTableViewController: UITableViewController {
    
    var groupList = [Group]()
    var user: User!
    var fbGroupService: FirebaseFirestoreGroupService!
    var userGroupId = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fbGroupService = FirebaseFirestoreGroupService(vc: self, callback: self)
        fbGroupService.onUserGroupListChangeListener(user: user, isGroupFiltered: false)
        fbGroupService.getAllGroups(user: user)
        tableView.rowHeight = 60.0
    }
    
    // MARK: - TABLE VIEW DATA SOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellReusableGroup, for: indexPath) as! CustomGroupSearchCell
        cell.searchView_LBL_groupName.text = groupList[indexPath.row].groupName
        cell.searchView_LBL_creatorName.text = groupList[indexPath.row].getCreator()
        if userGroupId.contains(groupList[indexPath.row].getUUID()) {
            cell.accessoryType = .checkmark
        }
        cell.delegate = self
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !self.userGroupId.contains(groupList[indexPath.row].getUUID()) {
            fbGroupService.appendGroupToUser(user: user, group: groupList[indexPath.row])
        }else {
            
        }
        // Handle the problem of selection a row and it flashes
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

// MARK:- GROUP CALLBACK
extension SearchGroupTableViewController : GroupCallback {
   
    func onFinish(user: User,group: [Group]) {
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

// MARK: - SEARCH GROUP
extension SearchGroupTableViewController : UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fbGroupService.getGroupFilteredByName(name: searchBar.text!)
    }
}

// MARK: - EXTENSION SWIPE CELL
extension SearchGroupTableViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let action = SwipeAction(style: .default, title: "Add") { action, indexPath in
            print("Add action")
        }
        
        // customize the action appearance
        action.image = UIImage(named: "plus")
        
        return [action]
    }
}
