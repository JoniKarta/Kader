//
//  TodoListTableViewController.swift
//  Kader
//
//  Created by user165579 on 6/9/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController{
    
    var todoListArray:[TodoItem] = [TodoItem]()
    var fbItemService : FirebaseFirestoreItemService!
    var group: Group!
    var user: User!
    @IBOutlet weak var taskView_LBL_task: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fbItemService = FirebaseFirestoreItemService(vc: self, callback: self)
        fbItemService.getAllTodoItems(group: group)
    }
  
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoListArray.count
    }
    
    // Handle the cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellReusableItem, for: indexPath) as! CustomTaskCell
        cell.taskView_LBL_task.text = todoListArray[indexPath.row].task
        if todoListArray[indexPath.row].isDone == true {
            cell.taskView_LBL_doneBy.text = "Completed By: \(todoListArray[indexPath.row].completedBy)"
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
            cell.taskView_LBL_doneBy.text = "This task isn't completed yet"
        }
        return cell
    }
    
    // MARK: - Table view actions
    
    // Handle the selection of a single item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Handle the state of the current selected todo item
        fbItemService.setItemDone(user: user, group: group, todoItem: todoListArray[indexPath.row])
        
        // Handle the problem of selection a row and it flashes
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Plus Bar Button action
    
    @IBAction func todoList_BTN_addTask(_ sender: UIBarButtonItem) {
        var newTaskTextField = UITextField()
        let addItemDialog = UIAlertController(title:  "Add new task for the team", message:"", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item" , style: .default) { (action) in
            // Create new todoItem
            let todoItem = TodoItem(task: newTaskTextField.text!)
            
            self.fbItemService.setTodoItem(group: self.group, todoItem: todoItem)
        }
        
        addItemDialog.addTextField {
            (alertTextField) in alertTextField.placeholder = "Add new task for the team"
            newTaskTextField = alertTextField
        }
        addItemDialog.addAction(action)
        
        present(addItemDialog, animated: true, completion:nil)
    }
    
    
    
    // MARK - SEGUE TO CHAT
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatViewController" {
            let destinationViewController = segue.destination as! ChatViewController
            destinationViewController.group = self.group
        }
    }
    
    
    
    
    
}

// MARK: - Search in the todo list
extension TodoListTableViewController : UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                print(searchBar.text!)
    }
    
}

extension TodoListTableViewController: ItemCallback{
    func onFinish(itemList: [TodoItem]) {
        self.todoListArray = itemList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}




