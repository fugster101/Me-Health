import UIKit

class MoreCustomCellView: UITableViewCell {
    
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var moreImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
