//
//  TodoListTableViewController.swift
//  Kader
//
//  Created by user165579 on 6/9/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit
import ChameleonFramework

class TodoListTableViewController: UITableViewController{
      
    @IBOutlet weak var taskView_LBL_task: UILabel!
    
    // Firebase item service utility
    var fbItemService : FirebaseFirestoreItemService!
    
    // Hold the todo items which will be displayed
    var todoList:[TodoItem] = [TodoItem]()
    
    // Hold the group that contain the todoItems
    var group: Group!
    
    // Hold the current user
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbItemService = FirebaseFirestoreItemService(vc: self, callback: self)
        fbItemService.getAllTasks(group: group)
    }
  
    
    // MARK: -  TABLE VIEW DATA SOURCE
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellReusableItem, for: indexPath) as! CustomTaskCell
        cell.taskView_LBL_task.text = todoList[indexPath.row].task
        if todoList[indexPath.row].isDone == true {
            cell.taskView_LBL_doneBy.text = "Completed By: \(todoList[indexPath.row].completedBy)"
                cell.taskView_VIEW_taskContent.backgroundColor = FlatMintDark()
                cell.taskView_LBL_doneBy.textColor = ContrastColorOf(FlatGreenDark(), returnFlat: true)
                cell.taskView_LBL_task.textColor = ContrastColorOf(FlatGreenDark(), returnFlat: true)
                
            } else {
            cell.taskView_LBL_doneBy.text = "This task isn't completed yet"
                cell.taskView_VIEW_taskContent.backgroundColor = FlatRedDark()
                cell.taskView_LBL_doneBy.textColor = ContrastColorOf(FlatRedDark(), returnFlat: true)
                cell.taskView_LBL_task.textColor = ContrastColorOf(FlatRedDark(), returnFlat: true)
                
            }
        return cell
    }
    
    // MARK: - TABLE VIEW ACTION
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if todoList[indexPath.row].isDone != true{
            fbItemService.updateTaskState(user: user, group: group, todoItem: todoList[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - ADD TASK
    
    @IBAction func todoList_BTN_addTask(_ sender: UIBarButtonItem) {
        var newTaskTextField = UITextField()
        let addItemDialog = UIAlertController(title:  "Add new task for the team", message:"", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item" , style: .default) { (action) in
            let todoItem = TodoItem(task: newTaskTextField.text!)
            self.fbItemService.addTask(group: self.group, todoItem: todoItem)
        }
        
        addItemDialog.addTextField {
            (alertTextField) in alertTextField.placeholder = "Add new task for the team"
            newTaskTextField = alertTextField
        }
        addItemDialog.addAction(action)
        addItemDialog.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(addItemDialog, animated: true, completion:nil)
    }
    
    
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatViewController" {
            let destinationViewController = segue.destination as! ChatViewController
            destinationViewController.group = self.group
            destinationViewController.user = self.user
        }
    }
    
}

// MARK: - SEARCH DELEGATE

extension TodoListTableViewController : UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fbItemService.getTasksFilteredByName(group: self.group, name: searchBar.text!)
    }
    
}

// MARK: - ITEM CALLBACK
extension TodoListTableViewController: ItemCallback{
    func onFinish(itemList: [TodoItem]) {
        self.todoList = itemList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}




