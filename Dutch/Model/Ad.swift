//
//  LykeModel.swift
//  WhatILyke
//
//  Created by Apple on 26/03/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct Ad {
    
    var id: Int?
    var categoryId: Int
    var title: String
    var alias: String?
    var description: String
    var price: Double
//    var isPricable: Int?
    var address1: String?
    var address2: String?
    var address3: String?
    var phone: String?
    var views: Int?
    var published: Int?
    var userId: Int
    var image: String
    var createdAt: String?
    var updatedAt: String?
    var user: User?
    var category: Category?
    var images: [Image]?
    
    static func homeAdsFromJSONArray(jsonArray: [JSON]) -> [Ad] {
        return jsonArray.flatMap{ jsonItem -> Ad in
            let id = jsonItem[""]["id"].intValue
            let categoryId = jsonItem[""]["category_id"].intValue
            let title = jsonItem[""]["title"].stringValue
            let alias = jsonItem[""]["alias"].stringValue
            let description = jsonItem[""]["description"].stringValue
            let price = jsonItem[""]["price"].doubleValue
            let address1 = jsonItem[""]["address1"].stringValue
            let address2 = jsonItem[""]["address2"].stringValue
            let address3 = jsonItem[""]["address3"].stringValue
            let phone = jsonItem[""]["phone"].stringValue
            let views = jsonItem[""]["views"].intValue
            let published = jsonItem[""]["published"].intValue
            let userId = jsonItem[""]["user_id"].intValue
            let image = jsonItem[""]["image"].stringValue
            let createdAt = jsonItem[""]["created_at"].stringValue
            let updatedAt = jsonItem[""]["updated_at"].stringValue
            let user = User.userFromJSONData(jsonData: jsonItem[""]["user"])
            let category = Category.categoryFromJSONData(jsonData: jsonItem[""]["category"])
            let images = Image.imagesFromJSONArray(jsonArray: jsonItem[""]["images"].arrayValue)
            

            return Ad(id:id, categoryId:categoryId, title:title, alias:alias, description:description,
                      price:price, address1:address1, address2:address2, address3:address3, phone:phone,
                      views:views, published:published, userId:userId, image:image, createdAt:createdAt, updatedAt:updatedAt, user:user, category:category, images:images)
            
        }
    }
    
    static func adsFromJSONArray(jsonArray: [JSON]) -> [Ad] {
        return jsonArray.flatMap{ jsonItem -> Ad in
            let id = jsonItem["id"].intValue
            let categoryId = jsonItem["category_id"].intValue
            let title = jsonItem["title"].stringValue
            let alias = jsonItem["alias"].stringValue
            let description = jsonItem["description"].stringValue
            let price = jsonItem["price"].doubleValue
            let address1 = jsonItem["address1"].stringValue
            let address2 = jsonItem["address2"].stringValue
            let address3 = jsonItem["address3"].stringValue
            let phone = jsonItem["phone"].stringValue
            let views = jsonItem["views"].intValue
            let published = jsonItem["published"].intValue
            let userId = jsonItem["user_id"].intValue
            let image = jsonItem["image"].stringValue
            let createdAt = jsonItem["created_at"].stringValue
            let updatedAt = jsonItem["updated_at"].stringValue
            let user = User.userFromJSONData(jsonData: jsonItem["user"])
            let category = Category.categoryFromJSONData(jsonData: jsonItem["category"])
            let images = Image.imagesFromJSONArray(jsonArray: jsonItem["images"].arrayValue)
            
            
            return Ad(id:id, categoryId:categoryId, title:title, alias:alias, description:description,
                      price:price, address1:address1, address2:address2, address3:address3, phone:phone,
                      views:views, published:published, userId:userId, image:image, createdAt:createdAt, updatedAt:updatedAt, user:user, category:category, images:images)
            
        }
    }
    

}

extension Ad {
    
    init(categoryId:Int, title:String, description:String, price:Double, address1:String,
         address2:String, address3:String, phone:String, published:Int, userId:Int, image:String) { //image & upload
        
        self.categoryId = categoryId
        self.title = title
        self.description = description
        self.price = price
        self.address1 = address1
        self.address2 = address2
        self.address3 = address3
        self.phone = phone
        self.published = published
        self.userId = userId
        self.image = image
        
    }
    
    
}








