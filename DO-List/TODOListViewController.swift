//
//  ViewController.swift
//  DO-List
//
//  Created by Samuel Bartlett on 28/11/2018.
//  Copyright © 2018 Samuel Bartlett. All rights reserved.
//

import UIKit

class TODOListViewController: UITableViewController {
    
    
    let defs = UserDefaults.standard
    var itemArray: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defs.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
    }
    
    //MARK - TableView Data Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //pull the default cell out of the View
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //set text value of the cell to required item (currently from array)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //allow a dynamic table view so items can be added and displayed
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //debug current cell clicked
        print(itemArray[indexPath.row])
        
        //add or remove checkmarks
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //unhighlight the cell after press
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new Items to list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Create a textField that is globally accessible by the method
        var textField = UITextField()
        
        //set up the alert
        let alert = UIAlertController(title: "Add new TODO Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //check if the text field is blank
            if textField.text != nil{
                
                //if not add item to the array and update the tableView
                self.itemArray.append(textField.text!)
                self.defs.set(self.itemArray, forKey: "TodoListArray")
                self.tableView.reloadData()
            }
        }
        
        //Add a text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            //make the text field globaly accessible to the method
            textField = alertTextField
        }
        
        //add the action to the alert and present the alert
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

