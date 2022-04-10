
import UIKit
import Charts
import SnapKit
import SafariServices

protocol UpdateDelegate: AnyObject {
    func didUpdate(sender: HomeViewController)
}
struct CategoryLogPass: Codable {
    var icon: Data
    var categoryTitle: String
    var log: [String]
    var cost: [Double]
    init(icon: UIImage, categoryTitle: String, log: [String], cost: [Double]) {
        self.icon = icon.pngData()!
        self.categoryTitle = categoryTitle
        self.log = log
        self.cost = cost
    }
    func match(string: String) -> Bool {
        return log.contains { log in
            log.localizedCaseInsensitiveContains(string)
        }
    }
}
class HomeViewController: UIViewController, UITabBarControllerDelegate, ChartViewDelegate {
    static var data: [CategoryLogPass] =
    [CategoryLogPass(icon: UIImage(named: "icons8-grocery-64")!, categoryTitle: "Grocery", log: ["Bread", "Milk"], cost: [1.00, 1.00]),
     CategoryLogPass(icon: UIImage(named: "icons8-grocery-64")!, categoryTitle: "Household", log: ["Detergent", "Soap"], cost: [5.00, 5.00]),
    CategoryLogPass(icon: UIImage(named: "icons8-grocery-64")!, categoryTitle: "Snacks", log: ["Chocolate", "Candies"], cost: [1.00, 1.00]),
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
        pieChart.delegate = self
        notificationUpdates()
        getExpense()
        tableView.delegate = self
        tableView.dataSource = self
//        localDataSave()
        balance.delegate = self
        configureBalanceSave()
        configureResult()
        loadSavedData()
        dissmissingKeyboard()
        currencyBalance.text = "$"
        view.addSubview(chartView)
        chartView.addSubview(pieChart)
        addConstraints()
        addSagmentControl()

        self.navigationController?.navigationBar.isTranslucent = true
        addLogo()
        getRandomColors()
        if traitCollection.userInterfaceStyle == .dark{
            self.tabBarController?.tabBar.backgroundColor = .darkGray
            self.navigationController?.navigationBar.backgroundColor = .darkGray
        } else {
            self.tabBarController?.tabBar.backgroundColor = .white
            self.navigationController?.navigationBar.backgroundColor = .white
        }
    }
//MARK: - Add Logo - Get Colors
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
   func getRandomColors() {
       HomeViewController.arrayofRandomColors.removeAll()
        for _ in 0..<HomeViewController.data.count {
            HomeViewController.arrayofRandomColors.append(.random())
        }
        print("HomeViewController.arrayofRandomColors.count = \(HomeViewController.arrayofRandomColors.count)")
    }
    //MARK: - Chart
    let chartView = UIView()
    var pieChart = PieChartView()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureChart()
    }
    func configureChart() {
        var entries = [ChartDataEntry]()
        for i in 0..<HomeViewController.data.count {
            entries.append(ChartDataEntry(x: HomeViewController.data[i].cost.reduce(0, +), y: HomeViewController.data[i].cost.reduce(0, +)))
        }
        let set = PieChartDataSet(entries: entries)
        set.label = ""
        let legend = pieChart.legend
        legend.enabled = false
        set.colors = HomeViewController.arrayofRandomColors
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        func dissmissingKeyboard() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
            pieChart.addGestureRecognizer(tapGesture)
            tapGesture.cancelsTouchesInView = false
        }
        dissmissingKeyboard()
    }
// Constraints for Chart:
    var topConst: ConstraintMakerEditable? = nil
    var bottomConst: ConstraintMakerEditable? = nil
    var rightConst: ConstraintMakerEditable? = nil
    var leftConst: ConstraintMakerEditable? = nil
    func addConstraints() {
        //        pieChart.frame = CGRect(x: 0, y: 0, width: chartView.frame.size.width, height: chartView.frame.size.height)
        chartView.backgroundColor = .clear
        chartView.snp.makeConstraints { chartView in
            rightConst = chartView.right.equalTo(view.snp.right)
            leftConst = chartView.left.equalTo(view.snp.left)
            bottomConst = chartView.bottom.equalTo(addButton).offset(-40)
            topConst = chartView.top.equalTo(result).offset(15)
        }
        
        //        rightConst?.constraint.activate()
        //        leftConst?.constraint.activate()
        //        bottomConst?.constraint.activate()
        //        topConst?.constraint.activate()
        pieChart.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.chartView)
        }
    }
    @IBOutlet weak var tableViewTopConst: NSLayoutConstraint!
    @IBOutlet weak var buttonViewToptoLabelViewBottom: NSLayoutConstraint!
    var switchCollapse = false
    
    @IBAction func collapseTap(_ sender: UIButton) {
        switchCollapse.toggle()
        print(switchCollapse)
        
        if switchCollapse == true {
            sender.setTitle("Show", for: .normal)
            UIView.animate(withDuration: 0.5) {
//                self.tableViewTopConst.constant = 300
                self.chartView.removeFromSuperview()
                self.tableViewTopConst.constant = 200
                self.buttonViewToptoLabelViewBottom.constant = 20
//                self.bottomConst?.constraint.update(offset: -180)
//                self.chartView.layoutIfNeeded()
            } completion: { _ in
               print("fuck")
            }
        } else {
            sender.setTitle("Collapse", for: .normal)
            self.view.addSubview(chartView)
            addConstraints()
            self.buttonViewToptoLabelViewBottom.constant = 170
            self.tableViewTopConst.constant = 360
//            self.bottomConst?.constraint.update(offset: -40)
        }
    }
//MARK: - Properties
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
    var iconImage = Data()
    static var currentIndex = 0
    var arrayofIndexPathRows = [Int]()
    static var arrayofRandomColors = [UIColor]()
    var iconVC = IconViewController()
    static let singletonHomeVC = HomeViewController()
    @IBOutlet weak var currencyBalance: UILabel!
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Data.plist")
    let encoder = PropertyListEncoder()
    lazy var latestImage = UIImage()
    var indexPathRow = Int()
    static var selectedIndexArray = [Int]()
    static var selectedIndex: Int? {
        didSet {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "select"), object: nil, userInfo: ["selectedIndex": selectedIndex])
        }
    }
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addButtonTapped(_ sender: Any) {
        addCategory()
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var result: UILabel!
    @IBAction func exchange(_ sender: Any) {
       let url = URL(string: "https://www1.oanda.com/currency/converter/")
        if url != nil {
            let vc = SFSafariViewController(url: url!)
            present(vc, animated: true)
        } else {
            return
        }
    }
    //MARK: - User Interaction for the Icons
    func dissmissingKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.balance.endEditing(true)
        defaults.set(balance.text, forKey: "balanceKey")
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.performSegue(withIdentifier: "gotoIcons", sender: self)
    }
    
    @objc func titleTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.performSegue(withIdentifier: "goToDetail", sender: self)
    }
    @objc func cellTitleTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    }
//MARK: - Expense Calculation Functions, Balance, Currency Sign Updates
    
    lazy var selectedRowHome = Int()
    lazy var sumArray = [Double]()
    func configureResult() {
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
            result.text = "Enter Balance"
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
//MARK: - NotificationUpdates

    func notificationUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.getExpenseUpdate), name: NSNotification.Name(rawValue: "newdata"), object: nil)
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeCurrencySign), name: NSNotification.Name(rawValue: "newCurrency"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.signUpdate), name: NSNotification.Name(rawValue: "newCurrency"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeCurrencySign), name: NSNotification.Name(rawValue: "newCurrency"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateIconArray), name: NSNotification.Name(rawValue: "newHomeModel"), object: nil)
    }
    @objc func loadList(notification: NSNotification) {
        let indexPath = IndexPath(item: IconViewController.indexPathRowBack ?? 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    //MARK: - Local Data
//    func localDataSave() {
//        if let dataSaved = UserDefaults.standard.value(forKey:"dataSaved") as? Data {
//           let savedData = try? PropertyListDecoder().decode(Array<CategoryLogPass>.self, from: dataSaved)
//            HomeViewController.data = savedData!
//        }
//    }
    func loadSavedData() {
        if let currencySaved = UserDefaults.standard.value(forKey:"currencySaved") as? String {
            currencySignTap = currencySaved
        }
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                HomeViewController.data = try decoder.decode([CategoryLogPass].self, from: data)
            } catch {
                print("error decoding savedData == \(error)")
            }
        }
    }
    func saveData() {
        do {
            let data = try self.encoder.encode(HomeViewController.data)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("error, \(error)")
        }
    }
    func configureBalanceSave() {
        let balanceSaved = UserDefaults.standard.value(forKey:"balanceKey") as? String
        if balanceSaved != nil, balanceSaved != "" {
            balance.text = balanceSaved!

        result.text = String(Double(balance.text!)! - Double(expenseLabel.text!)!)
        } else {
            print("error balanceSaved")
        }
    }
    func getLastRow() -> Int {
        let lastSectionIndex = self.tableView.numberOfSections - 1
        let lastRowIndex = self.tableView.numberOfRows(inSection: lastSectionIndex) - 1
        return lastRowIndex
    }
    //MARK: - Sagmentation
        enum SegmentType: String {
            case categories = "Categories"
            case new = "New"
        }
    var segments: [SegmentType] = [.categories]
        lazy var segmentControl: UISegmentedControl = {
            let sc = UISegmentedControl(items: segments.map({ $0.rawValue }))
            sc.layer.cornerRadius = 5
            sc.backgroundColor = .black
            sc.tintColor = .white
            sc.selectedSegmentIndex = 0
            sc.addTarget(self, action: #selector(actionofSC), for: .valueChanged)
            sc.backgroundColor = .green
            return sc
        }()
    @objc func actionofSC() {
        let type = segments[segmentControl.selectedSegmentIndex]
        switch type {
        case .categories:
            print("categories")
        case .new:
            print("new")
            HomeViewController.data.removeAll()
            tableView.reloadData()
        }
    }
    func addSagmentControl(){
        self.view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { sagmentedControl in
            sagmentedControl.bottom.equalTo(tableView.snp.top).offset(-5)
            sagmentedControl.top.equalTo(addButton.snp.bottom).offset(5)
            sagmentedControl.right.equalTo(view).offset(-40)
            sagmentedControl.left.equalTo(view).offset(40)
        }
        removeTabButton.snp.makeConstraints { removeTabButton in
            removeTabButton.bottom.equalTo(tableView.snp.top).offset(-5)
            removeTabButton.top.equalTo(addButton.snp.bottom).offset(5)
            removeTabButton.right.equalTo(view).offset(-5)
            removeTabButton.left.equalTo(segmentControl.snp.right).offset(5)
        }
        
    }
    @IBAction func addSegmentButton(_ sender: Any) {
            segmentControl.insertSegment(withTitle: "New", at: segmentControl.numberOfSegments, animated: true)
            segments.append(.new)
    }
    @IBOutlet weak var removeTabButton: UIButton!
    @IBAction func RemoveTab(_ sender: Any) {
        if segments.count > 0 {
            segmentControl.removeSegment(at: segmentControl.numberOfSegments-1, animated: true)
                segments.removeLast()
        }
    }
}

//MARK: - TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
        @objc func changeCurrencySign() {
            let currencySaved = UserDefaults.standard.value(forKey:"currencySaved") as? String
            if currencySaved != nil {
                currencySignTap = currencySaved!
                currencyBalance.text = currencySignTap
            } else {
                currencySignTap = CurrencyViewController.currencyCode
                currencyBalance.text = ""
            }
            tableView.reloadData()
        }
    @objc func updateIcon(notification: Notification) {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeViewController.data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCell
// Notifications and gesture.
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeCurrencySign), name: NSNotification.Name(rawValue: "newCurrency"), object: nil)
        HomeViewController.rowsTableView = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tapGesture.cancelsTouchesInView = false
        categoryCell.icon.addGestureRecognizer(tapGesture)
// Cell config
        
        if currencySignTap != "" {
            categoryCell.cost.text = "\(sumCategory[indexPath.row]) \(currencySignTap)"
            print("currencySignTap in cellforrowAt = \(currencySignTap)")
        } else {
            categoryCell.cost.text = "\(sumCategory[indexPath.row]) $"
        }
        categoryCell.category.text = HomeViewController.data[indexPath.row].categoryTitle
        categoryCell.icon.image = UIImage(data: HomeViewController.data[indexPath.row].icon)
        categoryCell.category.textColor = HomeViewController.arrayofRandomColors.uniqued()[indexPath.row]
        categoryCell.cost.textColor = HomeViewController.arrayofRandomColors.uniqued()[indexPath.row]
        return categoryCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        HomeViewController.selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        HomeViewController.selectedIndexArray.append(indexPath.row)
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
//MARK: - Swipe Actions and Methods
    private func handleMoveToTrash() {
        print("Moved to trash")
        HomeViewController.data.remove(at: HomeViewController.rowHome)
        self.tableView.reloadData()
        saveData()
    }
    func addCategory() {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
        HomeViewController.data.append(CategoryLogPass(icon: UIImage(named: "icons8-grocery-64")!, categoryTitle: self.textField1.text!, log: ["Swipe to Edit"], cost: [0]))
        self.saveData()
        self.getRandomColors()
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
            HomeViewController.data[HomeViewController.rowHome].categoryTitle = textField.text!
            self.saveData()
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
//MARK: - Textfield Delegate Methods
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        configureResult()
        balance.resignFirstResponder()
        return true
        }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if balance.text != "" || string != "" {
            let res = (balance.text ?? "") + string
            return Double(res) != nil
        }
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        userinteractionIs = true
        defaults.set(balance.text, forKey: "balanceKey")
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        configureResult()
    }
}
//MARK: - Random Color
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
// MARK: - Extension for Hex code Colors
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")
       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }
   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
