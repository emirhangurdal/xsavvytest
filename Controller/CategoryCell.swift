
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
    }
}
