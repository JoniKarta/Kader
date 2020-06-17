//
//  User.swift
//  Kader
//
//  Created by user165579 on 6/12/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation

class User: Codable, CustomStringConvertible{
    
    var userEmail: String = ""
    var groupListId: [String] = [String]()
    
    init(userEmail: String) {
        self.userEmail = userEmail
    }
    init() {
        
    }
    public var description: String {
        return "User Email: \(self.userEmail)"
    }
}
