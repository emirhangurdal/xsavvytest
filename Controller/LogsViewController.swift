

import UIKit
class LogsViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate {
    lazy var x = Int()
    lazy var sumOfLogs = [Int]()
    lazy var numberOfItems = Int()
    lazy var rowLogs = Int()
    lazy var sectionLogs = Int()
    lazy var itemArray = [[String]]()
    var filteredItemData = [CategoryLogPass]()
    lazy var costArray = [[Double]]()
    static var forSumofCostArray = [Double]()
    static var sumFinal = Double()
    var SwipeSelectedSectionNo = Int()
    var swipeSelectedRowNo = Int()
    var categoryCostArray = [String]()
    var data = [CategoryLogPass]()
    var tappedCell = Int()
    var tappedSection = Int()
    var newLogCount = [Int]()
    var newItemArray = [String]()
    var newCostArray = [Double]()
    var newSumofLogs = [Int]()
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!

    func getLogs() -> Int {
        for i in 0..<self.data.count {
            x = self.data[i].log.count
            sumOfLogs.append(x)
    }
                return sumOfLogs.reduce(0, +)
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .clear
        if #available(iOS 13.0, *) {
            navBarProb()
        } else {
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.tintColor = .white
        }
        data = HomeViewController.data
        for i in 0..<self.data.count {
            itemArray.append(self.data[i].log)
            costArray.append(self.data[i].cost)
            LogsViewController.forSumofCostArray.append(costArray[i].reduce(0, +))
        }
        filteredItemData = data
        LogsViewController.sumFinal = LogsViewController.forSumofCostArray.reduce(0, +)
        numberOfItems = getLogs()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newdata"), object: nil)
        self.tableView.keyboardDismissMode = .onDrag
        addLogo()

    }
//MARK: - Add Logo
    
    func addLogo() {
         let logoView = UIImageView()
        logoView.image = UIImage(named: "Applogo")
         logoView.contentMode = .scaleAspectFit
         logoView.translatesAutoresizingMaskIntoConstraints = false
         
         if let navC = self.navigationController{
             navC.navigationBar.addSubview(logoView)
             logoView.centerXAnchor.constraint(equalTo: navC.navigationBar.centerXAnchor).isActive = true
             logoView.centerYAnchor.constraint(equalTo: navC.navigationBar.centerYAnchor, constant: 0).isActive = true
             logoView.widthAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, multiplier: 0.2).isActive = true
             logoView.heightAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, multiplier: 0.088).isActive = true
         }
    }
    
 //MARK: - dissmiss keyboard
    
    func dissmissingKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.tableView.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.searchBar.endEditing(true)
    }
    
//MARK: - NavBar Appearance
    
    @available(iOS 13.0, *)
    func navBarProb() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        // Customizing our navigation bar
        navigationController?.navigationBar.tintColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    @objc func refresh(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        if let myData = userInfo["data"] as? [CategoryLogPass] {
            self.data = myData
            filteredItemData = myData
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
        }
        LogsViewController.sumFinal = LogsViewController.forSumofCostArray.reduce(0, +)
        self.tableView.reloadData()
   }
    
    //MARK: - SearchBar
    var isFiltering: Bool = false
    var filteredCost = [[Double]]()
    func searchBar(_ searchBarF: UISearchBar, textDidChange searchText: String) {
        searchBarF.text = searchBar.text
        if searchText.isEmpty {
            filteredItemData.removeAll()
            isFiltering = false
        }
        else
        {
            filteredItemData = data.filter { data in
                return data.match(string: searchText)
            }
            print("filteredItemData = \(filteredItemData)")
            isFiltering = true
        }
        tableView.reloadData()
    }
}


//MARK: - TableViewDelegate Methods

extension LogsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return itemArray[section].count
        return isFiltering ? filteredItemData[section].log.count : itemArray[section].count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
//       return self.data.count
        return isFiltering ? filteredItemData.count : self.data.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        sectionView.backgroundColor = .clear
        let sectionTitle = UILabel(frame: CGRect(x: 15, y: 0, width: sectionView.frame.width - 15, height: 30))
//      sectionTitle.font = UIFont(name: "RiseofKingdom", size: 20)
        sectionTitle.font = UIFont(name: "Optima-Bold", size: 19)
//        sectionTitle.text = self.data[section].categoryTitle
        sectionTitle.text = isFiltering ? "Search Result" : self.data[section].categoryTitle
        
        sectionView.addSubview(sectionTitle)
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let logCell = tableView.dequeueReusableCell(withIdentifier: "logCell") as! LogItemCell
        rowLogs = indexPath.row
        sectionLogs = indexPath.section
//        logCell.logTitle.text = itemArray[indexPath.section][indexPath.row]
        
        logCell.logTitle.textColor = isFiltering ? .blue : HomeViewController.arrayofRandomColors[indexPath.section]
        logCell.cost.textColor = isFiltering ? .blue : HomeViewController.arrayofRandomColors[indexPath.section]
        
        logCell.icon.image = UIImage(named: "feather-pen64px")

        print("sectionLogs = \(sectionLogs)")
        print("indexPath.row = \(rowLogs)")
        
        logCell.logTitle.text = isFiltering ? filteredItemData[indexPath.section].log[indexPath.row] :
        itemArray[indexPath.section][indexPath.row]
        print(costArray[indexPath.section])
        logCell.cost.text = isFiltering ? String(filteredItemData[indexPath.section].cost[indexPath.row]) :
        String(costArray[indexPath.section][indexPath.row])
        return logCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedCell = indexPath.row
        tappedSection = indexPath.section
        configureCostEdit()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
//MARK: - Swipe Actions
    private func handleMoveToTrash() {
        print("Moved to trash")
        HomeViewController.data[SwipeSelectedSectionNo].log.remove(at: swipeSelectedRowNo)
        HomeViewController.data[SwipeSelectedSectionNo].cost.remove(at: swipeSelectedRowNo)
        do {
            let data = try HomeViewController.singletonHomeVC.encoder.encode(HomeViewController.data)
            try data.write(to: HomeViewController.singletonHomeVC.dataFilePath!)
        } catch {
            print("error, \(error)")
        }
//        HomeViewController.singletonHomeVC.defaults.set(try? PropertyListEncoder().encode(HomeViewController.data), forKey: "dataSaved")
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
        let alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            if textFieldEditLog.text != "" {
                HomeViewController.data[self.SwipeSelectedSectionNo].log[self.swipeSelectedRowNo] = textFieldEditLog.text!
            }
        // Save:
            do {
                let data = try HomeViewController.singletonHomeVC.encoder.encode(HomeViewController.data)
                try data.write(to: HomeViewController.singletonHomeVC.dataFilePath!)
            } catch {
                print("error, \(error)")
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Edit Item"
            textFieldEditLog = alertTextField
        }
        alert.addAction(action)
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
    func configureCostEdit() {
        var textFieldCost = UITextField()
        let alert = UIAlertController(title: "Change the Cost", message: "", preferredStyle: .alert)
        let actionChangeCost = UIAlertAction(title: "Done", style: .default) { (action2) in
            if let cost = Double(textFieldCost.text!) {
                HomeViewController.data[self.tappedSection].cost[self.tappedCell] = cost
                
            } else {
                HomeViewController.data[self.tappedSection].cost[self.tappedCell] = 0.00
            }
            do {
                let data = try HomeViewController.singletonHomeVC.encoder.encode(HomeViewController.data)
                try data.write(to: HomeViewController.singletonHomeVC.dataFilePath!)
            } catch {
                print("error, \(error)")
            }
        }
        alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Edit Cost"
        textFieldCost = alertTextField
                }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        alert.addAction(actionChangeCost)
        present(alert, animated: true, completion: nil)
    }
}
extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter(
            { element == $0.element })
            .map({ $0.offset })
    }
}


