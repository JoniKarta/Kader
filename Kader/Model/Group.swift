//
//  Group.swift
//  Kader
//
//  Created by user165579 on 6/12/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation

class Group: Codable {
    
    var groupName: String = ""
    private var creator: String = ""
    var itemList: [TodoItem] = [TodoItem]()
    
    init(groupName: String, creator: String) {
        self.groupName = groupName
        self.creator = creator
    }
    
    func getCreator() -> String {
        return creator
    }
}
