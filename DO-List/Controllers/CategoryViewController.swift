//
//  CategoryViewController.swift
//  DO-List
//
//  Created by Samuel Bartlett on 04/12/2018.
//  Copyright © 2018 Samuel Bartlett. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray: [Category] = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.reloadData()
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TODOListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

    //MARK - TableView Data Sources
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //set text value of the cell to required item (currently from array)
        let currItem = categoryArray[indexPath.row]
        cell.textLabel?.text = currItem.title
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //allow a dynamic table view so items can be added and displayed
        return categoryArray.count
    }
    
    
    //MARK - Data manipulation Methods
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("Error saving context with error \(error)")
        }
        tableView.reloadData()
    }

    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error fetching data \(error)")
        }
        tableView.reloadData()
    }
    
    func deleteItem(item: TodoItem, rowIndex: Int){
        context.delete(item)
        categoryArray.remove(at: rowIndex)
    }
    
    //MARK - Add New Categories
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        
        //Create a textField that is globally accessible by the method
        var textField = UITextField()
        
        //set up the alert
        let alert = UIAlertController(title: "Add new TODO List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add List", style: .default) { (action) in
            //check if the text field is blank
            if textField.text != nil{
                //if not add item to the array and update the tableView
                let newCategory = Category(context: self.context)
                newCategory.title = textField.text!
                self.categoryArray.append(newCategory)
                self.saveItems()
            }
        }
        
        //Add a text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new list"
            
            //make the text field globaly accessible to the method
            textField = alertTextField
        }
        
        //add the action to the alert and present the alert
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
