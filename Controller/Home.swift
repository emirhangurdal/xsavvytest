//
//  ViewController.swift
//  XSavvy
//
//  Created by Emir Gurdal on 11.07.2021.
//

//Home Table View Will Contain Categories. Each category will go to their own log page. - Provide defaults.
//Slide and delete will be available for each cell. Each cell will be editable by the user. Swipe right to edit, swipe lef to delete. Include alert "Are you sure for delete option".
//Each cell contains an icon, a title, and price label. - total expense will be calculated by sum of each price label from TaV.
//Balance and Expense will have a red and blue color.
//A chart will be available.

import UIKit

protocol UpdateDelegate: AnyObject {
    func didUpdate(sender: HomeViewController)
}



struct CategoryLogPass: Codable {
    var categoryTitle: String
    var log: [String]
    var cost: [Double]
    
//    var numberOfItems: Int {
//           return log.count
//       }
//
//       subscript(index: Int) -> String {
//           return log[index]
//       }
    
    
}




class HomeViewController: UIViewController, UITabBarControllerDelegate {
    
    

        
    

    static var data: [CategoryLogPass] =
        
    
        [CategoryLogPass(categoryTitle: "Grocery", log: ["Bread", "Milk"], cost: [1.00, 2.00]),
         CategoryLogPass(categoryTitle: "Games", log: ["MAD", "COD"], cost: [1.00, 5.00]),
         CategoryLogPass(categoryTitle: "KOM", log: ["Tum", "Mar"], cost: [1.00, 10.00]),
        ]
    
    {
        
        willSet {
            
           
        }
        
        didSet {
          
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let logsVC = storyboard.instantiateViewController(identifier: "LogsView") as? LogsViewController
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newdata"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newdata"), object: nil, userInfo: ["data": HomeViewController.data])
            
          
            
        }
    }
    
    
    
    
    

    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    weak var delegate: UpdateDelegate?
    let defaults = UserDefaults.standard
    var textField1 = UITextField()
    static var rowHome = Int()
    static var rowsTableView = Int()
    var dataCount: Int?
    

    
    @IBAction func addButtonTapped(_ sender: Any) {
    
        addCategory()
        
    }
    

    
   
    @IBOutlet weak var tableView: UITableView!
   
    lazy var sumArray = [Double]()
    
    @objc func getExpenseUpdate(notification: Notification) {
        
        
        
        guard let userInfo = notification.userInfo else {return}
        if let myData = userInfo["data"] as? [CategoryLogPass] {
            
            sumArray.removeAll()

            for i in 0..<myData.count {
                
                sumArray.append(contentsOf: myData[i].cost)
            }
       
            
        }
        
        expenseLabel.text = String("\(sumArray.reduce(0, +))$")
        
        print("sumArray.reduce(0, +) in getExpenseUpdate() == \(sumArray.reduce(0, +))")
       
        
    }
    
    func getExpense() {
        
        for i in 0..<HomeViewController.data.count {
            
            sumArray.append(contentsOf: HomeViewController.data[i].cost)
        }
        print(sumArray.reduce(0, +))
        
        
        
        LogsViewController.sumFinal = sumArray.reduce(0, +)
        expenseLabel.text = String("\(LogsViewController.sumFinal)$")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.getExpenseUpdate), name: NSNotification.Name(rawValue: "newdata"), object: nil)
        getExpense()
        
    
        tableView.delegate = self
        tableView.delegate = self
//        localDataSave()
        
        
    }
    
  
    


    
    func localDataSave() {
        
        if let dataSaved = UserDefaults.standard.value(forKey:"dataSaved") as? Data {
           let savedData = try? PropertyListDecoder().decode(Array<CategoryLogPass>.self, from: dataSaved)
            HomeViewController.data = savedData!
        } 
        
    }
    
    
    

    
    func getLastRow() -> Int {
       
        let lastSectionIndex = self.tableView.numberOfSections - 1
        let lastRowIndex = self.tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
            return lastRowIndex
      
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
        
        
        return HomeViewController.data.count
        
    }
    
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCell
       
        HomeViewController.rowsTableView = indexPath.row
      
        
//        Dictionary(grouping: currentStat.statEvents, by: \.name)
    

        categoryCell.icon.backgroundColor = .blue // catery icon.
        categoryCell.cost.text = "1$" //sum of logsview items cost array that belong to a particular category.
        categoryCell.category.text = HomeViewController.data[indexPath.row].categoryTitle
     
        
        
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


    private func handleMoveToTrash() {
        print("Moved to trash")
        
        HomeViewController.data.remove(at: HomeViewController.rowHome)
        self.tableView.reloadData()
        self.defaults.set(try? PropertyListEncoder().encode(HomeViewController.data), forKey: "dataSaved")
      
    }
    
    
    func addCategory() {
        
        
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            HomeViewController.data.append(CategoryLogPass(categoryTitle: self.textField1.text!, log: ["Swipe to Edit"], cost: [0]))

            self.defaults.set(try? PropertyListEncoder().encode(HomeViewController.data), forKey: "dataSaved")
            
            self.tableView.reloadData()
           
                
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
            
            HomeViewController.data[HomeViewController.rowHome].categoryTitle = textField.text!
            
            self.defaults.set(try? PropertyListEncoder().encode(HomeViewController.data), forKey: "dataSaved")
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
        
        HomeViewController.rowHome = indexPath.row
      
        
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
        HomeViewController.rowHome = indexPath.row
        
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



    
