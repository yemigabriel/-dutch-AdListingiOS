//
//  GroupModel.swift
//  WhatILyke
//
//  Created by Apple on 11/03/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Image {
    
    var id: Int
    var image: String
    var itemId: Int?
    var published: Int?
    var s3key: String?
    var createdAt: String
    var updatedAt: String
    
    
    
    static func imagesFromJSONArray(jsonArray: [JSON]) -> [Image] {
        return jsonArray.flatMap{ jsonItem -> Image in
            
            let id = jsonItem["images"]["id"].intValue
            let image = jsonItem["images"]["image"].stringValue
            let itemId = jsonItem["images"]["item_id"].intValue
            let published = jsonItem["images"]["published"].intValue
            let s3key = jsonItem["images"]["s3key"].stringValue
            let createdAt = jsonItem["images"]["created_at"].stringValue
            let updatedAt = jsonItem["images"]["updated_at"].stringValue
            
            return Image(id: id, image: image, itemId: itemId, published: published, s3key: s3key, createdAt: createdAt, updatedAt: updatedAt)
        }
    }
    
    
    
    
}


