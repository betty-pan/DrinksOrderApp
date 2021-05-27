//
//  Order.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/4/25.
//

import Foundation

class OrderData {
    var drinkName:String?
    var drinkSize:Size?
    var drinkSugar:Sugar?
    var drinkIce:Ice?
    var addOn:AddOn?
    var totalPrice:Int?
    
    internal init(
        drinkName: String?,
        drinkSize: Size?,
        drinkSugar: Sugar?,
        drinkIce: Ice?,
        addOn: AddOn?,
        totalPrice: Int? ){
        self.drinkName = drinkName
        self.drinkSize = drinkSize
        self.drinkSugar = drinkSugar
        self.drinkIce = drinkIce
        self.addOn = addOn
        self.totalPrice = totalPrice
    }
    
    
}


