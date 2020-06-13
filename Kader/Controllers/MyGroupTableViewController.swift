//
//  CategoryTableViewController.swift
//  Kader
//
//  Created by user165579 on 6/10/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase

class MyGroupTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var groupList = [Group]()
    var fbService: FBGroupService!
    var user : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        fbService = FBGroupService(callback: self)
        fbService.getFilteredGroups(selectedGroupList: user.selectedGroupsList)
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    // Handle the cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellReusableSelectedGroup, for: indexPath)
        
        cell.textLabel?.text = groupList[indexPath.row].groupName
        return cell
    }
    
    // Segue to TodoListTableViewController while pressing on a single category item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.taskSegue, sender: self)
    }
    
    // Preperation for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.taskSegue {
            let destinationVC = segue.destination as! TodoListTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.group = groupList[indexPath.row]
            }
        }else if segue.identifier == K.searchGroupSegue {
            
        }
        
    }
    
    // MARK: - ADD NEW Group to the list
    
    @IBAction func category_BTN_add(_ sender: UIBarButtonItem) {
        var newTaskTextField = UITextField()
        let addItemDialog = UIAlertController(title: "Add new group to schedule your missions", message:"", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Group" , style: .default) { (action) in
            let newGroup = Group(groupName: newTaskTextField.text!, creator: "Jonathan@gmail.com")
            self.groupList.append(newGroup)
            self.fbService.setGroup(newGroup: newGroup)
            self.fbService.appendGroupToUser(user: self.user, group: newGroup)
            self.tableView.reloadData()
        }
        
        addItemDialog.addTextField {
            (alertTextField) in alertTextField.placeholder = "Add new category for the team"
            newTaskTextField = alertTextField
        }
        addItemDialog.addAction(action)
        present(addItemDialog, animated: true, completion:nil)
    }
}


extension MyGroupTableViewController: GroupCallback {
    func onFinish(group: [Group]) {
        if !group.isEmpty {
            self.groupList = group
            self.tableView.reloadData()
        }
    }
}
