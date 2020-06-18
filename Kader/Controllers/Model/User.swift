//
//  User.swift
//  Kader
//
//  Created by user165579 on 6/12/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation

class User: Codable{
    
    var userEmail: String = ""
    var userName: String  = ""
    var groupListId: [String] = [String]()
    
    init(userEmail: String, userName: String) {
        self.userEmail = userEmail
        self.userName = userName
    }
    
    init() {
        
    }
    
}
