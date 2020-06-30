//
//  Group.swift
//  Kader
//
//  Created by user165579 on 6/12/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation
import UIKit
class Group: Codable {
    
    private var uuid = UUID.init().uuidString
    private var creator: String = ""
    var groupName: String = ""
    
    var groupImageUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case uuid, creator, groupName
    }
    
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
    
}
