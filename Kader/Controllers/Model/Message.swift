//
//  Message.swift
//  Kader
//
//  Created by user165579 on 6/17/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation

class Message: Codable {
    
    var sender: String = ""
    var body: String = ""
    var dateIntervalTime : Double
    
    init(sender: String, body:  String) {
        self.sender = sender
        self.body = body
        self.dateIntervalTime = Date().timeIntervalSince1970
    }
    
}
