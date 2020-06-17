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
import SwipeCellKit

class MyGroupTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var groupList = [Group]()
    var fbGroupService: FirebaseFirestoreGroupService!
    var user : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        fbGroupService = FirebaseFirestoreGroupService(vc: self, callback: self)
        fbGroupService.onUserGroupListChangeListener(user: user, isGroupFiltered: true)
        
    }
    
    // MARK: - TABLE VIEW DATA SROUCE
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    // Handle the cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellReusableSelectedGroup, for: indexPath) as! CustomGroupCell
        cell.groupView_LBL_groupName.text = groupList[indexPath.row].groupName
        cell.groupView_LBL_creator.text = groupList[indexPath.row].getCreator()
        cell.groupView_IMG_role.image = user.userEmail != groupList[indexPath.row].getCreator() ? #imageLiteral(resourceName: "soldier") : #imageLiteral(resourceName: "commander")
        cell.delegate = self
        return cell
    }
    
    // Segue to TodoListTableViewController while pressing on a single category item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.taskSegue, sender: self)
    }
    
    // MARK: - SEGUE
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
    
    // MARK: - ADD GROUP
    
    @IBAction func mygroupview_BTN_addgroup(_ sender: UIBarButtonItem) {
        var newTaskTextField = UITextField()
        let addGroupAlertDialog = UIAlertController(title: "Add new group to schedule your missions", message:"", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Group" , style: .default) { (action) in
            let newGroup = Group(groupName: newTaskTextField.text!, creator: self.user.userEmail)
            self.fbGroupService.setGroup(user: self.user, newGroup: newGroup)
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
    
    
    //MARK: - LOG OUT
    @IBAction func groupview_BTN_logout(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            fbGroupService.listener?.remove()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }    }
    
}

    //MARK: - GROUP ON FINISH CALLBACK
extension MyGroupTableViewController: GroupCallback {
   
    func onFinish(user: User, group: [Group]) {
            self.groupList = group
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
}

// MARK: - EXTENSION SWIPE CELL

extension MyGroupTableViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }

    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
        self.fbGroupService.removeGroupFromUser(user: self.user, group: self.groupList[indexPath.row])
        
        
    }

    // customize the action appearance
    deleteAction.image = UIImage(named: "delete")
        
    return [deleteAction]
    }

    
}
