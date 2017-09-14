//
//  MemberModel.swift
//  WhatILyke
//
//  Created by Apple on 13/03/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import Foundation
import SwiftyJSON


fileprivate let photoBase = "http://dutch.ng/uploads/users/"
struct User {
    
    var id: Int?
    var name: String
    var email: String
    var phone: String?
    var avatar: String?
    var provider: String?
    var providerId: String?
    var createdAt: String?
    var updatedAt: String?
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "id" : id ?? 0,
            "name" : name,
            "email" : email,
            "phone" : phone ?? "" ,
            "avatar" : avatar ?? "",
            "provider" : provider ?? "",
            "providerId" : providerId ?? "",
            "createdAt" : createdAt ?? "",
            "updatedAt" : updatedAt ?? ""
        ]
    }
    static func usersFromJSONArray(jsonArray: [JSON]) -> [User] {
        return jsonArray.flatMap{ jsonItem -> User in
            
            let id = jsonItem["user"]["id"].intValue
            let name = jsonItem["user"]["name"].stringValue
            let email = jsonItem["user"]["email"].stringValue
            let phone = jsonItem["user"]["phone"].stringValue
            let avatar = "\(photoBase)\(jsonItem["user"]["avatar"].stringValue)" //TODO: check for http...
            let provider = jsonItem["user"]["provider"].stringValue
            let providerId = jsonItem["user"]["provider_id"].stringValue
            let createdAt = jsonItem["user"]["created_at"].stringValue
            let updatedAt = jsonItem["user"]["updated_at"].stringValue
            
            return User(id: id, name: name, email: email, phone:phone, avatar: avatar, provider: provider, providerId: providerId, createdAt: createdAt, updatedAt: updatedAt)
        }
    }
    
    static func userFromJSONData(jsonData: JSON) -> User {
        
        let id = jsonData["user"]["id"].intValue
        let name = jsonData["user"]["name"].stringValue
        let email = jsonData["user"]["email"].stringValue
        let phone = jsonData["user"]["phone"].stringValue
        let avatar = "\(photoBase)\(jsonData["user"]["avatar"].stringValue)" //TODO: check for http...
        let provider = jsonData["user"]["provider"].stringValue
        let providerId = jsonData["user"]["provider_id"].stringValue
        let createdAt = jsonData["user"]["created_at"].stringValue
        let updatedAt = jsonData["user"]["updated_at"].stringValue
        
        return User(id: id, name: name, email: email, phone:phone, avatar: avatar, provider: provider, providerId: providerId, createdAt: createdAt, updatedAt: updatedAt)
        
    }
    
}

extension User {
    
    init(name:String, email:String) {
        self.name = name
        self.email = email
    }
}







