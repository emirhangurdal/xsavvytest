//
//  ViewController.swift
//  XSavvy
//
//  Created by Emir Gurdal on 11.07.2021.
//

import UIKit

protocol HomeDelegate {
    func dataCount(count: Int)
}

struct CategoryLogPass {
    var categoryArray: String
    var log: [String]
    var cost: [Double]
}



class HomeViewController: UIViewController {
    
    var delegate: HomeDelegate?
    
    var textField1 = UITextField()
    


    var rowHome = 0
    var rowsTableView = 0
    var x: Int {
        get {
            data.count
        }
        
        set {
            
            
        }
        

    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        addCategory()
        
        
    }
    
   
    
    
    var data: [CategoryLogPass] = [CategoryLogPass(categoryArray: "Grocery", log: ["Chocolate Bar", "Bread"], cost: [3, 1]),
                CategoryLogPass(categoryArray: "Coffee", log: ["Latte", "Filter Coffee"], cost: [2, 1]),
                CategoryLogPass(categoryArray: "Rent", log: ["Home", "Office"], cost: [2, 1]),
                CategoryLogPass(categoryArray: "Clothing", log: ["Shirt", "Pants"], cost: [2, 1])
    ]
    
        
    
    
    //Home Table View Will Contain Categories. Each category will go to their own log page. - Provide defaults.
    //Slide and delete will be available for each cell. Each cell will be editable by the user. Swipe right to edit, swipe lef to delete. Include alert "Are you sure for delete option".
    //Each cell contains an icon, a title, and price label. - total expense will be calculated by sum of each price label from TaV.
    //Balance and Expense will have a red and blue color.
    //A chart will be available.

    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    
        
        tableView.delegate = self
        tableView.delegate = self
        
        
    }
    

    
//    func addconstraints() {
//
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
//        let constraints: [NSLayoutConstraint] = [
//
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 300),
//            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5),
//
//
//
//
//]
//
//        NSLayoutConstraint.activate(constraints)
//
//    }
    


}



//MARK:- TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        

        
        return data.count
        
    }
    
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCell
        
        
        categoryCell.icon.backgroundColor = .blue
        categoryCell.cost.text = "1$"
        categoryCell.category.text = data[indexPath.row].categoryArray
        
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        

    }


    private func handleMoveToTrash() {
        print("Moved to trash")
        self.data.remove(at: rowHome)
        self.tableView.reloadData()
    }
    
    
     func addCategory() {
   
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on our UI alert
            
            self.data.append(CategoryLogPass(categoryArray: self.textField1.text!, log: [""], cost: [0]))

      

            
            
       //modify this to change the indextPath.row cell.
            self.tableView.reloadData()
            self.x = self.tableView.numberOfSections
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Category"
            self.textField1 = alertTextField
            
        }
        
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }

    private func goToEdit() {
       
       var textField = UITextField()
        
        let alert = UIAlertController(title: "Type Category Name", message: "", preferredStyle: .alert)
        
      
        
        
        let action = UIAlertAction(title: "Edit Category", style: .default) { (action) in
            // what will happen once the user clicks the add item button on our UI alert
            
            self.data[self.rowHome].categoryArray = textField.text!
            
       //modify this to change the indextPath.row cell.     append(textField.text!)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Edit Category Title"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        rowHome = indexPath.row
        
        let edit = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
                                            self?.goToEdit()
                                            completionHandler(true)
            
            
        }
        edit.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [edit])
        
        


    }
    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        rowHome = indexPath.row
        
        let trash = UIContextualAction(style: .destructive,
                                       title: "Delete") { [weak self] (action, view, completionHandler) in
                                        self?.handleMoveToTrash()
                                        completionHandler(true)
            

        }
        
        
        trash.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        
        return configuration
        
        
    }
    
    
}

