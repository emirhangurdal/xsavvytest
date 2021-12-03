
import UIKit
struct CurrencyModel {
    var currency: String
    var currencyCode: String
}
class CurrencyOptCell: UITableViewCell {
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var currencySign: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
class CurrencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static var currencyCode = String() {
        didSet {
            HomeViewController.singletonHomeVC.defaults.set(currencyCode, forKey: "currencySaved")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newCurrency"), object: nil, userInfo: ["currency": CurrencyViewController.currencyCode])
        }
    }
    static var currencyArray: [CurrencyModel] = [
        CurrencyModel(currency: "The US Dollar", currencyCode: "$"),
        CurrencyModel(currency: "Euro", currencyCode: "€"),
        CurrencyModel(currency: "Japanese Yen, 円", currencyCode: "¥"),
        CurrencyModel(currency: "British Pound", currencyCode: "£"),
        CurrencyModel(currency: "Canadian Dollar", currencyCode: "CA$"),
        CurrencyModel(currency: "Australian Dollar", currencyCode: "A$"),
        CurrencyModel(currency: "Turkish Lira", currencyCode: "₺"),
        CurrencyModel(currency: "UAE Dirham", currencyCode: "د.إ"),
        CurrencyModel(currency: "Renminbi, 人民幣", currencyCode: "¥"),
        CurrencyModel(currency: "Russian Ruble, рубль", currencyCode: "₽"),
        CurrencyModel(currency: "Indian Rupee, रुपया", currencyCode: "₹"),
        CurrencyModel(currency: "Iranian Rial, ریال ایران‎", currencyCode: "﷼"),
        CurrencyModel(currency: "Egyptian Pound, جنيه مصرى‎", currencyCode: "ج.م"),
        CurrencyModel(currency: "Brazilian Real", currencyCode: "R$"),
        CurrencyModel(currency: "Mexican Peso", currencyCode: "$"),
    ]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrencyViewController.currencyArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell") as! CurrencyOptCell
        cell.currencyLbl.text = CurrencyViewController.currencyArray[indexPath.row].currency
        cell.currencySign.text = CurrencyViewController.currencyArray[indexPath.row].currencyCode
    
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true) {
        }
        
        CurrencyViewController.currencyCode = CurrencyViewController.currencyArray[indexPath.row].currencyCode
        print(CurrencyViewController.currencyArray[indexPath.row].currencyCode)
    }
}



