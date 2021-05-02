//
//  OrderListTableViewCell.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/5/1.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkInfoLabel: UILabel!
    @IBOutlet weak var ordererLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
