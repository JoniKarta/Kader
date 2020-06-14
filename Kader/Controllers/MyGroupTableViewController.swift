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
    var fbService: FirebaseFirestoreGroupService!
    var user : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        fbService = FirebaseFirestoreGroupService(vc: self, callback: self)
        fbService.onUserGroupListChangeListener(user: user)
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
            let destinationController = segue.destination as! TodoListTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationController.group = groupList[indexPath.row]
            }
        }else if segue.identifier == K.searchGroupSegue {
            let destinationController = segue.destination as! SearchGroupTableViewController
            destinationController.user = self.user
        }
        
    }
    
    // MARK: - ADD NEW Group to the list
    
    @IBAction func mygroupview_BTN_addgroup(_ sender: UIBarButtonItem) {
        var newTaskTextField = UITextField()
        let addGroupAlertDialog = UIAlertController(title: "Add new group to schedule your missions", message:"", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Group" , style: .default) { (action) in
            let newGroup = Group(groupName: newTaskTextField.text!, creator: self.user.userEmail)
            self.fbService.appendGroupToUser(user: self.user, group: newGroup)
            self.fbService.setGroup(newGroup: newGroup)
            self.tableView.reloadData()
        }
        
        // Set the placeholder of the text and get the text from it
        addGroupAlertDialog.addTextField {
            (alertTextField) in alertTextField.placeholder = "Add new group for your team"
            newTaskTextField = alertTextField
        }
        
        addGroupAlertDialog.addAction(action)
        addGroupAlertDialog.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(addGroupAlertDialog, animated: true, completion:nil)
    }
}


extension MyGroupTableViewController: GroupCallback {
    func onFinish(user: User, group: [Group]) {
        print("on Finish gets called from MyGroupTableViewController")
        if !group.isEmpty {
            self.groupList = group
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
