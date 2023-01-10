//
//  TableViewCell.swift
//  JsonListApp
//
//  Created by ko_matsumoto on 2023/01/10.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var SubTitle: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Cost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
