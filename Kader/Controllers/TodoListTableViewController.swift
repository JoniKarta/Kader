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
    var fbItemService : FBItemService!
    var group: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbItemService = FBItemService(callback: self)
        fbItemService.getAllTodoItem(group: group)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoListArray.count
    }
    
    // Handle the cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellReusableItem, for: indexPath)
        
        cell.textLabel?.text = todoListArray[indexPath.row].task
        let currentSelectedTask = todoListArray[indexPath.row]
        cell.accessoryType = currentSelectedTask.isSelected == true ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Table view actions
    
    // Handle the selection of a single item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Handle the state of the current selected todo item
        todoListArray[indexPath.row].isSelected = !todoListArray[indexPath.row].isSelected
        
        tableView.reloadData()
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
            
            self.fbItemService.setTodoItem(newGroup: self.group, todoItem: todoItem)
            // Add new item to the list
            self.todoListArray.append(todoItem)
            // Reload the data after its has been added
            self.tableView.reloadData()
        }
        
        addItemDialog.addTextField {
            (alertTextField) in alertTextField.placeholder = "Add new task for the team"
            newTaskTextField = alertTextField
        }
        addItemDialog.addAction(action)
        
        present(addItemDialog, animated: true, completion:nil)
    }
}

// MARK: - Search in the todo list
extension TodoListTableViewController : UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for item in todoListArray {
            if item.task.contains(searchBar.text!){
                print(item.task)
            }
        } 
    }
}

extension TodoListTableViewController: ItemCallback{
    func onFinish(itemList: [TodoItem]) {
        if !itemList.isEmpty {
            self.todoListArray = itemList
            self.tableView.reloadData()
        }
    }
}

