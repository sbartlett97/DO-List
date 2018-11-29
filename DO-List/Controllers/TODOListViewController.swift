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
    var itemArray = [todoItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("todoItems.plist")    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.reloadData()
    }
    
    //MARK - TableView Data Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //pull the default cell out of the View
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //set text value of the cell to required item (currently from array)
        let currItem = itemArray[indexPath.row]
        cell.textLabel?.text = currItem.title
        cell.accessoryType = currItem.done ? .checkmark : .none
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //allow a dynamic table view so items can be added and displayed
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //debug current cell clicked
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //unhighlight the cell after press
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
        tableView.reloadData()
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
                let newItem: todoItem = todoItem(text: textField.text!)
                self.itemArray.append(newItem)
                self.saveItems()
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
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error!")
        }
    }
    
    func loadData(){
        let decoder = PropertyListDecoder()
        do{
            let data = try Data(contentsOf: dataFilePath!)
            itemArray = try decoder.decode([todoItem].self, from: data)
        }catch{
            
        }
    }
}

