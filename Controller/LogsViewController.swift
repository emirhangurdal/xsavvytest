//
//  LogsViewController.swift
//  XSavvy
//
//  Created by Emir Gurdal on 12.07.2021.
//


// Will contain each expense item like coffee - $5, grocery $25 etc.
// Sorting and search categories included.
// When plus tapped, goes to edit page. Make actions for editing same method as homeVC. Information will be kept locally or in Firebase.
// Each item will go to a category from the home's TableView.

import UIKit

class LogsViewController: UIViewController {
   
    lazy var x = Int()
    lazy var sumOfLogs = [Int]()
    lazy var numberOfItems = Int()
    lazy var rowLogs = Int()
    lazy var sectionLogs = Int()
    lazy var itemArray = [[String]]()
    lazy var costArray = [[Double]]()
    static var forSumofCostArray = [Double]()
    static var sumFinal = Double()
    
    var SwipeSelectedSectionNo = Int()
    var swipeSelectedRowNo = Int()
    
    
 

    
    
    var categoryCostArray = [String]()
    

     var data = [CategoryLogPass]()
    
    func getLogs() -> Int {

        for i in 0..<self.data.count {

            x = self.data[i].log.count
            sumOfLogs.append(x)

    }
                return sumOfLogs.reduce(0, +)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
 
        data = HomeViewController.data
        
    
       
        for i in 0..<self.data.count {
            
            itemArray.append(self.data[i].log)
            costArray.append(self.data[i].cost)
            
            LogsViewController.forSumofCostArray.append(costArray[i].reduce(0, +))
            
            print("LogsViewController.forSumofCostArray.reduce(0, +) == \(LogsViewController.forSumofCostArray.reduce(0, +))")
            print("forSumofCostArray == \(LogsViewController.forSumofCostArray)")
            print("costArray[i].reduce(0, +) == \(costArray[i].reduce(0, +))")
            
            
//            print("itemArray = \(itemArray)")
//            print("costArray = \(costArray)")

        }
        
        LogsViewController.sumFinal = LogsViewController.forSumofCostArray.reduce(0, +)
        print("LogsViewController.sumFinal in ViewDidLoad == \(LogsViewController.sumFinal)")

        
        numberOfItems = getLogs()
        tableView.delegate = self
        tableView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newdata"), object: nil)


    }
    
    
    
    var newLogCount = [Int]()
    var newItemArray = [String]()
    var newCostArray = [Double]()
    var newSumofLogs = [Int]()

    
    @objc func refresh(notification: Notification) {
        
        print("refresh working")
//        print(HomeViewController.data)
//        print(notification.userInfo!)
        
        
        
        guard let userInfo = notification.userInfo else {return}
        if let myData = userInfo["data"] as? [CategoryLogPass] {
            
            self.data = myData
            
            newSumofLogs.removeAll()
            
            func getLogs() -> Int {
                for i in 0..<data.count {
                    x = self.data[i].log.count
                    newSumofLogs.append(x)
                }
                return newSumofLogs.reduce(0, +)
            }
            
            
            numberOfItems = getLogs()
            
        }
        
        
        itemArray.removeAll()
        costArray.removeAll()
        LogsViewController.forSumofCostArray.removeAll()
        
        for i in 0..<self.data.count {
            
            itemArray.append(self.data[i].log)
            costArray.append(self.data[i].cost)
            
            LogsViewController.forSumofCostArray.append(costArray[i].reduce(0, +))
            print("LogsViewController.forSumofCostArray- DidSet ==\(LogsViewController.forSumofCostArray)")
            print("LogsViewController.forSumofCostArray.reduce(0, +) - DidSet == \(LogsViewController.forSumofCostArray.reduce(0, +)) ")
            
            //            print("itemArrayAfterDidSet = \(itemArray)")
            //            print("costArrayAfterDidSet = \(costArray)")
            
            
        }
        
        
        LogsViewController.sumFinal = LogsViewController.forSumofCostArray.reduce(0, +)
        print("LogsViewController.sumFinal- AfterDidSetOutside for in == \(LogsViewController.sumFinal)")
        
        
        
        print("LogsViewController.forSumofCostArray- AfterDidSetOutside for in ==\(LogsViewController.forSumofCostArray)")
        print("LogsViewController.forSumofCostArray.reduce(0, +) - AfterDidSetOutside for in== \(LogsViewController.forSumofCostArray.reduce(0, +)) ")
        //        print(itemArray)
        //        print(costArray)
        
        
        self.tableView.reloadData()
       
       
   }
    
    
    

    
 
    
}

//MARK:- TableView

extension LogsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
       

        
        return itemArray[section].count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
       return self.data.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        view.backgroundColor =  .clear
        let sectionTitle = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 30))
            
   
//        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        sectionTitle.font = UIFont(name: "RiseofKingdom", size: 20)
       
        
        sectionTitle.text = self.data[section].categoryTitle
        view.addSubview(sectionTitle)
        return view
    }
    
   
    private func handleMoveToTrash() {
        print("Moved to trash")
        HomeViewController.data[SwipeSelectedSectionNo].log.remove(at: swipeSelectedRowNo)
        HomeViewController.data[SwipeSelectedSectionNo].cost.remove(at: swipeSelectedRowNo)
        
    }
    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
   
        
        SwipeSelectedSectionNo = indexPath.section
        
        
        let trash = UIContextualAction(style: .destructive,
                                       title: "Delete") { [weak self] (action, view, completionHandler) in
                                        self?.handleMoveToTrash()
                                        completionHandler(true)
        }
        
        
        trash.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        return configuration
        
        
    }
    
    


    func editLog() {

        var textFieldEditLog = UITextField()
        var textFieldCost = UITextField()
        
        let alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: .alert)
        let alert2 = UIAlertController(title: "Edit Cost", message: "", preferredStyle: .alert)
   
        let action = UIAlertAction(title: "Change Name", style: .default) { (action) in
            
            HomeViewController.data[self.SwipeSelectedSectionNo].log[self.swipeSelectedRowNo] = textFieldEditLog.text ?? "edit"

            print(" HomeViewController.data[self.SwipeSelectedSectionNo].log[self.swipeSelectedRowNo] == \( HomeViewController.data[self.SwipeSelectedSectionNo].log[self.swipeSelectedRowNo])")
            
//            NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newdata"), object: nil)
            
            //self.defaults.set(try? PropertyListEncoder().encode(HomeViewController.data), forKey: "dataSaved")
        
        }
        
        let action2 = UIAlertAction(title: "Change Cost", style: .default) { (action2) in
            
            if let cost = Double(textFieldCost.text!) {
                HomeViewController.data[self.SwipeSelectedSectionNo].cost[self.swipeSelectedRowNo] = cost
                
            } else {
                HomeViewController.data[self.SwipeSelectedSectionNo].cost[self.swipeSelectedRowNo] = 0.00
            }
            
           

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Edit Item"
            textFieldEditLog = alertTextField
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Edit Cost"
            textFieldCost = alertTextField
            
        }
        
        
        
        
        alert.addAction(action)
        alert.addAction(action2)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
            
            
        }))
        
        
        
        present(alert, animated: true, completion: nil)


    }
    

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        swipeSelectedRowNo = indexPath.row
        SwipeSelectedSectionNo = indexPath.section

        let edit = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
                                            self?.editLog()
                                            completionHandler(true)


        }
        edit.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [edit])
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let logCell = tableView.dequeueReusableCell(withIdentifier: "logCell") as! LogItemCell
        
        rowLogs = indexPath.row
        sectionLogs = indexPath.section
  
        
        logCell.logTitle.text = itemArray[indexPath.section][indexPath.row]
        logCell.icon.image = UIImage(named: "feather-pen64px")
        logCell.cost.text = String(costArray[indexPath.section][indexPath.row])
        
        return logCell
        
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    
}


