//
//  ClientsTableViewCell.swift
//  FinalProyectDAM2
//
//  Created by DAMII on 24/04/25.
//

import UIKit

class MarketsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var marketNameLbl: UILabel!
    @IBOutlet weak var districtMarketLbl: UILabel!
    
    @IBOutlet weak var photoMarketIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
