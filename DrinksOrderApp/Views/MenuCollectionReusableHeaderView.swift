//
//  MenuCollectionReusableHeaderView.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/4/25.
//

import UIKit

class MenuCollectionReusableHeaderView: UICollectionReusableView {
    @IBOutlet weak var classicDrinksBtn: UIButton!
    @IBOutlet weak var limittedDrinksBtn: UIButton!
    
    override func awakeFromNib() {
        setBtnBoarder(limittedDrinksBtn)
        
    }
    func setBtnBoarder(_ button:UIButton) {
        //未被選中
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "Color")?.cgColor
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor(named: "Color"), for: .normal)
//
//
//            //選中
//            button.layer.borderWidth = 1
//            button.layer.borderColor = UIColor(named: "Color")?.cgColor
//            button.backgroundColor = UIColor(named: "Color")
//            button.setTitleColor(UIColor.white, for: .normal)
        
        
    }
    
}
