//
//  Group.swift
//  Kader
//
//  Created by user165579 on 6/12/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation

class Group: Codable, CustomStringConvertible {
    
    
    var groupName: String = ""
    private var creator: String = ""
    private var uuid = UUID.init().uuidString
    
    init(groupName: String, creator: String) {
        self.groupName = groupName
        self.creator = creator
    }
    
    func getCreator() -> String {
        return creator
    }
    
    func getUUID() -> String {
        return uuid
    }
    
    public var description: String {
        return "Group Name: \(self.groupName), Creator: \(self.creator)"
    }
}
