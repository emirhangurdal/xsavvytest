
import UIKit
class DetailVCCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cost: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class DetailCategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        if #available(iOS 13, *) {
            print("This code only runs on iOS 14 and up")
        } else {
            print("addSwipe() This code only runs on iOS 13 and lower")
        }

    }
    
//MARK: - Swipe
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeViewController.data[HomeViewController.selectedIndex ?? 0].log.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
                let label = UILabel()
                label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
                label.text = HomeViewController.data[HomeViewController.selectedIndex ?? 0].categoryTitle
                label.font = UIFont(name: "Optima-Bold", size: 19)
                label.textColor = .black
                headerView.addSubview(label)
                return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailVCCell") as! DetailVCCell
        cell.icon.image = UIImage(named: "feather-pen64px")
        if HomeViewController.data[HomeViewController.selectedIndex ?? 0].log[indexPath.row] != "Swipe to Edit" {
            cell.title.text = HomeViewController.data[HomeViewController.selectedIndex ?? 0].log[indexPath.row]
        } else {
            cell.title.text = "New item"
        }
        cell.cost.text = "\(String(HomeViewController.data[HomeViewController.selectedIndex ?? 0].cost[indexPath.row])) $"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismiss(animated: true, completion: nil)

    }

}
