//
//  CategoryTableViewController.swift
//  Kader
//
//  Created by user165579 on 6/10/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    var categotyList = [CategoryItem]()
    override func viewDidLoad() {
        let item1 = CategoryItem(title: "Running")
        let item2 = CategoryItem(title: "Walking")
        let item3 = CategoryItem(title: "Sleeping")
        categotyList.append(item1)
        categotyList.append(item2)
        categotyList.append(item3)
        super.viewDidLoad()
        
      
    }

    // MARK: - Table view data source

    

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categotyList.count
    }
    
    // Handle the cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categotyList[indexPath.row].title
       // let currentSelectedTask = categotyList[indexPath.row]
        
        return cell
    }
    
    // Handle the selection of a single item
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
          performSegue(withIdentifier: "todoListItems", sender: self)
       }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categotyList[indexPath.row]
        }
    }
   
    @IBAction func category_BTN_add(_ sender: UIBarButtonItem) {
    var newTaskTextField = UITextField()
          let addItemDialog = UIAlertController(title: "Add new categoty for the team", message:"", preferredStyle: .alert)
          
          let action = UIAlertAction(title: "Add Category" , style: .default) { (action) in
              // Create new todoItem
              let todoItem = CategoryItem(title: newTaskTextField.text!)
             
              // Add new item to the list
              self.categotyList.append(todoItem)

              // Reload the data after its has been added
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
    

