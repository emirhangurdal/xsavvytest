

import UIKit



class TabBarViewController: UITabBarController {

    

    
    

    var textField = UITextField()
    var textFieldCost = UITextField()
    var home = HomeViewController()
    let button = UIButton.init(type: .custom)
    
    @objc func buttonClicked() {
       
     
                let alert = UIAlertController(title: "Spent Money?", message: "Add New Item", preferredStyle: .alert)
                let alert2 = UIAlertController(title: "Category", message: "Choose Category", preferredStyle: .alert)
                let alert3 = UIAlertController(title: "Cost", message: "Type Cost/Price", preferredStyle: .alert)
                
        
            

                let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                    
                        
                     
                    
                        
                    for i in 0..<self.home.x {
        
         
                            alert2.addAction(UIAlertAction(title: self.home.data[i].categoryArray, style: .default, handler: { (action2) in
                                
                                

                            
                                alert3.addAction(UIAlertAction(title: "Cost", style: .default, handler: { (action3) in
                                    
                                    
                                    if let cost = Double(self.textFieldCost.text!) {
                                        self.home.data[i].cost.append(cost)
                                    } else {
                                        self.home.data[i].cost.append(0.00)
                                    }
                             
                                    
                                 
                                }))
                                
                          
                                self.home.data[i].log.append(self.textField.text!)
                                
                            
                                
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
                    self.textField = alertTextField
                }
                self.present(alert, animated: true, completion: nil)
                

        }
 
    
    
    


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

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // safe place to set the frame of button manually
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 64, height: 64)
    }


}
