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
        fbGroupService.onUserGroupListChangeListener(user: user, isGroupFiltered: false)
        fbGroupService.getAllGroups(user: user)
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

// MARK: - Search in the todo list
extension SearchGroupTableViewController : UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fbGroupService.getGroupFilteredByName(name: searchBar.text!)
    }
}//   override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let height = scrollView.frame.size.height
//        let contentYoffset = scrollView.contentOffset.y
//        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//        if distanceFromBottom < height {
//            if getData == false {
//                getData = true
//                pageSize = pageSize + 2
//                print("\(pageSize)")
//                fbGroupService.getAllGroups(user: user, pageSize: pageSize)
//            }
//        }
//    }
