//
//  DrinksCollectionViewCell.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/4/25.
//

import UIKit

class DrinksCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        indicatorView.isHidden = false
    }
    
}
