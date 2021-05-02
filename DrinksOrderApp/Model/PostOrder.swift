//
//  PostOrder.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/4/29.
//

import Foundation

struct PostOrder: Encodable{
    var data:OrderItem
}

struct OrderItem:Encodable {
    let orderer: String
    let drinkName: String
    let drinkSize: String
    let drinkSugar: String
    let drinkIce: String
    let addOn: String
    let totalPrice: String
}
