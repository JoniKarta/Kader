//
//  ItemModel.swift
//  Kader
//
//  Created by user165579 on 6/10/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation

class TodoItem: Codable, CustomStringConvertible{
    
    var task: String = ""
    var isDone : Bool = false
    var completedBy : String = ""
    
    init(task: String) {
        self.task = task
    }
    
    public var description: String {
        return "Task: \(self.task)"
    }
}
