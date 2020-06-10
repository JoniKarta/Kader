//
//  TodoListTableViewController.swift
//  Kader
//
//  Created by user165579 on 6/9/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    var testArray = ["Todo list 1", "Todo list 2", "Todo list 3", "Todo list 4"]
    var defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return testArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListItem", for: indexPath)
        
        cell.textLabel?.text = testArray[indexPath.row]
        return cell
    }
    
    // MARK: - Table view actions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    // MARK: - Bar Button item actions
    
    @IBAction func todoList_BTN_addTask(_ sender: UIBarButtonItem) {
        var newTaskTextField = UITextField()
        
        let addItemDialog = UIAlertController(title:  "Add new task for the team", message:"", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item" , style: .default) { (action) in
            // Add new item to the list
            self.testArray.append(newTaskTextField.text!)
            
            // Write the data to the local storage
            self.defaults.set(self.testArray, forKey: "Todolist")
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
