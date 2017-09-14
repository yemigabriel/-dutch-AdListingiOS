//
//  ListModel.swift
//  WhatILyke
//
//  Created by Apple on 26/03/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Category: CustomStringConvertible, Equatable, SearchableItem {

    var id: Int
    var title: String
    var alias: String?
    var parent_id: Int?
    var published: Int?
//    var parent: Category?
    var ad: [Ad]?
    
    var description: String {
        return title
    }
    
    func matchesSearchQuery(_ query: String) -> Bool {
        return title.lowercased().contains(query.lowercased())
    }
    
    static func categoryFromJSONData(jsonData: JSON) -> Category {
        
        let id = jsonData["category"]["id"].intValue
        let title = jsonData["category"]["title"].stringValue
        let alias = jsonData["category"]["alias"].stringValue
        let parent_id = jsonData["category"]["parent_id"].intValue
        let published = jsonData["category"]["published"].intValue
        
        
        return Category(id: id, title: title, alias: alias, parent_id: parent_id, published: published, ad: nil)
        
    }
    

}

func ==(rhs: Category, lhs: Category) -> Bool {
    return rhs.id == lhs.id
}

extension Category {
    
    
    init(id:Int, title:String) {
        self.id = id
        self.title = title
    }
}
