//
//  ViewController.swift
//  DO-List
//
//  Created by Samuel Bartlett on 28/11/2018.
//  Copyright © 2018 Samuel Bartlett. All rights reserved.
//

import UIKit
import RealmSwift

class TODOListViewController: UITableViewController{
    
    var itemsTodo: Results<todoItem>?
    var selectedCategory: Category?{
        didSet{
            loadData()
        }
    }
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    //MARK - TableView Data Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //pull the default cell out of the View
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //set text value of the cell to required item (currently from array)
        if let currItem = itemsTodo?[indexPath.row]{
            cell.textLabel?.text = currItem.title
            cell.accessoryType = currItem.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items added yet"
        }

        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //allow a dynamic table view so items can be added and displayed
        return itemsTodo?.count ?? 1
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //debug current cell clicked
        if let item = itemsTodo?[indexPath.row]{
            do{
               try realm.write{
                    item.done = !item.done

                }
            }catch{
                print("Error updating item status \(error)")
            }
        }
        tableView.reloadData()
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
                if let currentCategory = self.selectedCategory{
                    do {
                        try self.realm.write{
                            let newItem = todoItem()
                            newItem.title = textField.text!
                            currentCategory.items.append(newItem)
                        }
                    }catch{
                        print("error saving data to realm \(error)")
                    }
                }
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
    
    func loadData(){
        itemsTodo = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func deleteItem(item: todoItem){
        do{
            try realm.write{
                realm.delete(item)
            }
        }catch{
            print("Error deleting item \(error)")
        }
    }
    

}

extension TODOListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemsTodo = itemsTodo?.filter("title CONTAINS[cd] %@",  searchBar.text!).sorted(byKeyPath: "dateCreated")
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadData()
        }
    }
}

