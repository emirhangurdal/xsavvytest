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
    

    
    
    static let singletonHomeVC = HomeViewController()
    
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
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationUpdates()
        getExpense()
        tableView.delegate = self
        tableView.dataSource = self
        localDataSave()
        balance.delegate = self
        configureBalanceSave()
        configureResult()
       

    }

    
   
    
    
  
    
    
//MARK:- Properties
    var userinteractionIs = false
    @IBOutlet weak var balance: UITextField!
    @IBOutlet weak var expenseLabel: UILabel!
    weak var delegate: UpdateDelegate?
    let defaults = UserDefaults.standard
    var textField1 = UITextField()
    static var rowHome = Int()
    static var rowsTableView = Int()
    var dataCount: Int?
    lazy var currencySignTap = String()
    var selectedIndexPath = IndexPath()
    var indextPathForReload = Int()
    static var arrayofHomeVCselectedIndex = [Int]()
    static var arrayofIconVCicons = [UIImage]()
    
    static var selectedIcon = [Int:UIImage]()
        
     

    static var selectedIndex: Int? {
        didSet {

//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "select"), object: nil, userInfo: ["selectedIndex": selectedIndex])
            
            print("selectedIndex in didSet\(selectedIndex)")
            

        }

    }
    
    static var categoryIcon = UIImage()
    var indexPathRow = Int()
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        addCategory()
    }

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var result: UILabel!
    
    //MARK:- User Interaction for the Icons
    
    
    func dissmissingKeyboard() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
    
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
 //Above functions are not used.
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
                
        
        self.performSegue(withIdentifier: "gotoIcons", sender: self)
//        print("indexPathRow = \(indexPathRow)")
    }
    
    @objc func cellTitleTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
     
        
    }

    
    //MARK:- Expense Calculation Functions, Balance, Currency Sign Updates
    
     lazy var selectedRowHome = Int()
   
    lazy var sumArray = [Double]() {
        didSet {
            
        }
    }
    
    func configureResult() {
        
//        let balanceSaved = UserDefaults.standard.value(forKey:"balanceKey") as! String
//        print("balanceSaved = \(balanceSaved)")
//
//        balance.text = balanceSaved
        
        if Double(balance.text!) != nil {

            result.text = String(Double(balance.text!)! - sumArray.reduce(0, +))

            if Double(result.text!)! < 0.00 {
                result.textColor = .red
            } else if Double(result.text!)! == 0.00 {
                result.textColor = .black
            } else {
                result.textColor = .green
            }
            
        } else {
     
            result.text = "<- Please enter only numbers"
        }
        
    }
    
    @objc func getExpenseUpdate(notification: Notification) {
        
        guard let userInfo = notification.userInfo else {return}
        if let myData = userInfo["data"] as? [CategoryLogPass] {
    
            sumArray.removeAll()
            sumCategory.removeAll()
            
            for i in 0..<myData.count {
                sumArray.append(contentsOf: myData[i].cost)
                sumCategory.append(myData[i].cost.reduce(0, +))
            }
           
            tableView.reloadData()
        }
        if currencySignTap != "" {
            expenseLabel.text = String("\(sumArray.reduce(0, +)) \(currencySignTap)")
        } else {
            expenseLabel.text = String("\(sumArray.reduce(0, +))")
        }
        
        configureResult()
     
      
    }
    
    var sumCategory = [Double]()
    
    func getExpense() {
        
        for i in 0..<HomeViewController.data.count {
            sumArray.append(contentsOf: HomeViewController.data[i].cost)
            sumCategory.append(HomeViewController.data[i].cost.reduce(0, +))
        }
        

        LogsViewController.sumFinal = sumArray.reduce(0, +)
        
        
        if currencySignTap != "" {
            expenseLabel.text = String("\(LogsViewController.sumFinal) \(currencySignTap)")
        } else {
            expenseLabel.text = String("\(LogsViewController.sumFinal)")
        }
        
        configureResult()
        
    }
    
    @objc func signUpdate() {
        
        sumArray.removeAll()
        getExpense()
        
    }
    
//MARK:- NotificationUpdates

    func notificationUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.getExpenseUpdate), name: NSNotification.Name(rawValue: "newdata"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeCurrencySign), name: NSNotification.Name(rawValue: "newCurrency"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.signUpdate), name: NSNotification.Name(rawValue: "newCurrency"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
    }
    
    
   
    
    @objc func loadList(notification: NSNotification){
        
        tableView.reloadRows(at: [selectedIndexPath], with: .none)
//        tableView.reloadData()
        
    }
    
    
    
    //MARK:- Local Data

    func localDataSave() {
        if let dataSaved = UserDefaults.standard.value(forKey:"dataSaved") as? Data {
           let savedData = try? PropertyListDecoder().decode(Array<CategoryLogPass>.self, from: dataSaved)
            HomeViewController.data = savedData!
        }
    }
    
    func configureBalanceSave() {
        let balanceSaved = UserDefaults.standard.value(forKey:"balanceKey") as? String
        if balanceSaved != nil, balanceSaved != "" {
            balance.text = balanceSaved
            
            result.text = String(Double(balance.text!)! - Double(expenseLabel.text!)!)
        } else {
            
        }
    }
    
    
    func getLastRow() -> Int {
        let lastSectionIndex = self.tableView.numberOfSections - 1
        let lastRowIndex = self.tableView.numberOfRows(inSection: lastSectionIndex) - 1
        return lastRowIndex
    }
}





//MARK:- TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
        @objc func changeCurrencySign() {
            
            currencySignTap = CurrencyViewController.currencyCode
            tableView.reloadData()
        }
    
    
    @objc func updateIcon(notification: Notification) {
        tableView.reloadData()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeViewController.data.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCell
       
// Notifications and gesture.
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeCurrencySign), name: NSNotification.Name(rawValue: "newCurrency"), object: nil)
        
        HomeViewController.rowsTableView = indexPath.row
        
      
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tapGesture.cancelsTouchesInView = false
        categoryCell.icon.addGestureRecognizer(tapGesture)
        
//     let cellTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTitleTapped))
//     cellTapGesture.cancelsTouchesInView = true
//     categoryCell.addGestureRecognizer(cellTapGesture)
        
        
// Cell config.
        
        if currencySignTap != "" {
            categoryCell.cost.text = "\(sumCategory[indexPath.row]) \(currencySignTap)"
        } else {
            categoryCell.cost.text = "\(sumCategory[indexPath.row]) $"
        }
        
        categoryCell.category.text = HomeViewController.data[indexPath.row].categoryTitle
       
        
//        NotificationCenter.default.addObserver(self, selector: #selector(updateIndex), name: NSNotification.Name(rawValue: "select"), object: nil)
        
        
        indexPathRow = indexPath.row
//        print("indexPathRow = \(indexPathRow)")
        
        
        
        
        if IconViewController.indexPathRowBack == indexPath.row {
            
            if IconViewController.keyArray.uniqued().contains(IconViewController.indexPathRowBack) {
                
                categoryCell.icon.image = HomeViewController.selectedIcon[indexPath.row]
                
                
            } else {
                
                categoryCell.icon.image = UIImage(named: "icons8-grocery-64")
            }
            
            
        }
       
        
        
        
        
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        HomeViewController.selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
    }
    
    
    
    
    

//MARK:- Swipe Actions and Methods

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

//MARK:- Textfield Delegate Methods

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        balance.resignFirstResponder()
        defaults.set(balance.text, forKey: "balanceKey")
        return true
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        userinteractionIs = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
//
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//
//        var shouldClear = Bool()
//        if userinteractionIs == true {
//            shouldClear = true
//        }
//        return shouldClear
//
//
//    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        configureResult()
    }
    
}



    
