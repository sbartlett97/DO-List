//
//  ViewController.swift
//  DO-List
//
//  Created by Samuel Bartlett on 28/11/2018.
//  Copyright © 2018 Samuel Bartlett. All rights reserved.
//

import UIKit
import CoreData

class TODOListViewController: UITableViewController{
    
    var itemArray: [TodoItem] = [TodoItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
                let newItem = TodoItem(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
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
        do{
           try context.save()
        }catch{
            print("Error saving context with error \(error)")
        }
    }
    
    func loadData(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()){
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data \(error)")
        }
    }
    
    func deleteItem(item: TodoItem, rowIndex: Int){
        context.delete(item)
        itemArray.remove(at: rowIndex)
    }
    

}

extension TODOListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request);
    }
}

