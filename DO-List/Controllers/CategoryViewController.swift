//
//  CategoryViewController.swift
//  DO-List
//
//  Created by Samuel Bartlett on 04/12/2018.
//  Copyright © 2018 Samuel Bartlett. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryViewController: UITableViewController {
    
    var categoryArray: Results<Category>?
    let realm = try! Realm()
    
    
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
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }

    //MARK - TableView Data Sources
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //set text value of the cell to required item (currently from array)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No CAtegories added yet"
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //allow a dynamic table view so items can be added and displayed
        return categoryArray?.count ?? 1
    }
    
    
    //MARK - Data manipulation Methods
    func saveItems(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving realm with error \(error)")
        }
        tableView.reloadData()
    }

    func loadData(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
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
                let newCategory = Category()
                newCategory.name = textField.text!
                self.saveItems(category: newCategory)
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
