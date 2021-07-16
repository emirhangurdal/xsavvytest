//
//  CategoryCell.swift
//  XSavvy
//
//  Created by Emir Gurdal on 12.07.2021.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var cost: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
