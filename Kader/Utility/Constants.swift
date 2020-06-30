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
    
    struct Segue {
        static let groupToProfile = "ProfileSegue"
        static let registerToHome  = "RegisterToGroupList"
         static let loginToHome = "LoginToGroupList"
         static let homeToTaskList = "TaskItems"
         static let homeToSearch = "CustomizeGroups"
    }
    
    struct GroupFields {
        static let groupName = "groupName"
        static let groupUUID = "uuid"
        static let groupCreator = "creator"
    }
    
    struct UserFields {
        static let userGroupListId = "groupListId"
    }
}
