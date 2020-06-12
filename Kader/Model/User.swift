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
    var groupList: [Group] = [Group]()
    
    init(userEmail: String) {
        self.userEmail = userEmail
        
    }
}
