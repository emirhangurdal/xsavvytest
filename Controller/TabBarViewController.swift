

import UIKit





class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var textFieldTitle = UITextField()
    var textFieldCost = UITextField()
    let button = UIButton.init(type: .custom)
    func dissmissingKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @objc func buttonClicked() {
                let alert = UIAlertController(title: "Spent Money?", message: "Add New Item", preferredStyle: .alert)
                let alert2 = UIAlertController(title: "Category", message: "Choose Category", preferredStyle: .alert)
                let alert3 = UIAlertController(title: "Cost", message: "Type Cost/Price", preferredStyle: .alert)
                let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                    for i in 0..<HomeViewController.data.count {
                        alert2.addAction(UIAlertAction(title: HomeViewController.data[i].categoryTitle, style: .default, handler: { (action2) in
                            alert3.addAction(UIAlertAction(title: "Cost", style: .default, handler: { (action3) in
                                
                                if let cost = Double(self.textFieldCost.text!) {
                                    HomeViewController.data[i].cost.append(cost)
                                } else {
                                    HomeViewController.data[i].cost.append(0.00)
                                }
                                HomeViewController.data[i].log.append(self.textFieldTitle.text ?? "New")
                                do {
                                    let data = try HomeViewController.singletonHomeVC.encoder.encode(HomeViewController.data)
                                    try data.write(to: HomeViewController.singletonHomeVC.dataFilePath!)
                                } catch {
                                    print("error, \(error)")
                                }
                            }))
                            alert3.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                            }))
                            self.present(alert3, animated: true, completion: nil)
                        }) )
                    }
                    alert3.addTextField { (alertTextField) in
                        alertTextField.placeholder = "Price of the Item/Service"
                        self.textFieldCost = alertTextField
                    }
                    alert2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    }))
                    self.present(alert2, animated: true, completion: nil)
                }
                alert.addAction(action)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    }))
                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Add Item"
                    self.textFieldTitle = alertTextField
                }
                self.present(alert, animated: true, completion: nil)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        button.setImage(UIImage(named: "icon-plus-100"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.yellow, for: .highlighted)
        button.layer.borderColor = UIColor(rgb: 0x3498DB).cgColor
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        button.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
        tabBar.items?[0].title = "Categories"
        tabBar.items?[1].title = "All Items"
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Optima-Bold", size: 20)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Optima-Bold", size: 20)!], for: .selected)
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // safe place to set the frame of button manually
//        button.frame.size = CGSize(width: 120, height: 120)
        button.frame = CGRect.init(x: self.view.center.x - 30, y: self.tabBar.center.y - 65 , width: 64, height: 64)
    }
}




