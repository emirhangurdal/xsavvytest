

import UIKit





class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var textFieldTitle = UITextField()
    var textFieldCost = UITextField()
    let button = UIButton.init(type: .custom)
  
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
                             
                                    HomeViewController.data[i].log.append(self.textFieldTitle.text!)
                                 
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
    
  
//    private func setupChildViewControllers() {
//        guard let viewControllers = viewControllers else {
//            return
//        }
//
//        for vc in viewControllers {
//            var childViewController: UIViewController?
//
//            if let navigationController = vc as? UINavigationController {
//                childViewController = navigationController.viewControllers.first
//            } else {
//                childViewController = vc
//            }
//
//            switch childViewController {
//
//            case let vc as HomeViewController:
//                vc.data = TabBarViewController.data
//
//            case let vc as LogsViewController:
//                vc.data = TabBarViewController.data
//
//
//            default:
//                break
//            }
//
//        }
//
//
//    }
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        button.setImage(UIImage(named: "plusicon"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.yellow, for: .highlighted)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 32
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.white.cgColor
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        button.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
       
        
//        for navController in viewControllers! {
//            if let navController = navController as? UINavigationController,
//                let viewController = navController.viewControllers.first as? Injectable {
//                viewController.inject(data: self.dataFirst) //injection object is equal to data array.
//            }
//        }
    
    
  
      
    }
    
   

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // safe place to set the frame of button manually
        
        
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 64, height: 64)
    }


}




