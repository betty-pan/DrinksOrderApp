//
//  DrinkDetailTableViewCell.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/4/25.
//

import UIKit

class DrinkDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func selectOptionChangeImage(_ bool:Bool) {
        if bool {
            selectImageView.image = UIImage(systemName: "circle")
            selectImageView.image?.withTintColor(UIColor(named: "Color")!)
        }else{
            selectImageView.image = UIImage(systemName: "circle.fill")
            selectImageView.image?.withTintColor(UIColor(named: "Color")!)
        }
    }

}
