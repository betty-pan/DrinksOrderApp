//
//  Enums.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/4/26.
//

import Foundation

enum OptionTypes:String, CaseIterable {
    case size, sugar, ice, addOn
}
enum Ice: String, CaseIterable {
    case regularIce = "正常冰"
    case lessIce = "少冰"
    case halfIce = "微冰"
    case noIce = "去冰"
    case roomTemp = "常溫"
    case hot = "熱"
}
enum Sugar: String, CaseIterable {
    case regularSugar = "全糖"
    case lessSugar = "少糖"
    case halfSugar = "半糖"
    case lightSugar = "微糖"
    case noSugar = "無糖"
}
enum Size: String, CaseIterable {
    case medium = "中杯"
    case large = "大杯"
}
enum AddOn: String, CaseIterable {
    case whiteBubble = "白玉珍珠"
    case none = "不需加點"
}

