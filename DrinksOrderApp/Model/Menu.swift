//
//  Menu.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/4/24.
//

import Foundation

struct Menu:Codable {
    let feed:Feed
}
struct Feed:Codable {
    let entry: [DrinkData]
}

struct DrinkData:Codable {
    let drink:StringType
    let priceM:StringType
    let priceL:StringType
    let description:StringType
    let imageUrl:ImageURL
    
    enum CodingKeys: String, CodingKey {
        case drink = "gsx$drinks"
        case priceM = "gsx$pricem"
        case priceL = "gsx$pricel"
        case description = "gsx$description"
        case imageUrl = "gsx$imageurl"
    }
}

struct ImageURL:Codable {
    let url:URL
    enum CodingKeys: String, CodingKey {
        case url = "$t"
    }
}
struct StringType:Codable {
    let value:String
    enum CodingKeys: String, CodingKey {
        case value = "$t"
    }
}
