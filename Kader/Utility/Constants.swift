//
//  Constants.swift
//  Kader
//
//  Created by user165579 on 6/12/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation

struct K {
    
    static let appName = "Kader"
    static let registerSegue  = "RegisterToGroupList"
    static let loginSegue = "LoginToGroupList"
    static let taskSegue = "TaskItems"
    static let searchGroupSegue = "CustomizeGroups"
    
    static let cellReusableItem = "CellTodoItem"
    static let cellReusableGroup = "CellGroupItem"
    static let cellReusableSelectedGroup = "CellGroupSelectedItem"
    
    struct FireStore {
        static let usersCollection = "Users"
        static let groupsCollection = "Groups"
        static let tasksCollection = "Tasks" 
        static let userSubGroupCollection = "GroupList"
        static let chatCollection = "Chat"
        static let chatMessageCollection = "Messages"
        static let userProfileImage = "Profiles"
    }
    
    struct CellReusable {
        
    }
    
    struct Segue {
        static let groupToProfile = "ProfileSegue"
    }
    

}
