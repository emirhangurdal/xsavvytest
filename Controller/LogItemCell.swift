//
//  LogItemCell.swift
//  XSavvy
//
//  Created by Emir Gurdal on 28.07.2021.
//

import UIKit

class LogItemCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var logTitle: UILabel!
    
    @IBOutlet weak var cost: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    
        
       
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        

    }
    
    override func layoutSubviews() {
        
 
    }

}
