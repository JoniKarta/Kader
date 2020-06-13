//
//  FirebaseFirestoreService.swift
//  Kader
//
//  Created by user165579 on 6/13/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol GroupCallback {
    func onFinish(group: [Group])
}

class FirebaseFirestoreGroupService {
    let db = Firestore.firestore()
    let callback : GroupCallback?
    let vc : UIViewController
    var groupList : [Group] = [Group]()
    
    init(vc: UIViewController , callback: GroupCallback){
        self.callback = callback
        self.vc = vc
    }
    
    //MARK: - ADD GROUP
    func setGroup(newGroup: Group){
        let docRef =  db.collection(K.FireStore.groupsCollection).document(newGroup.groupName)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                Alert.displayAlertDialog(on: self.vc, title: "Group Already exists", message: "Sorry this group already exists try different name.")
            } else {
                docRef.setData(["groupName": newGroup.groupName, "creator":    newGroup.getCreator()])
            }
        }
    }
    
    // MARK: - USER GROUP LIST LISTENER
    func onUserGroupListChangeListener(user: User){
        db.collection(K.FireStore.usersCollection)
            .document(user.userEmail)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(String(describing: error))")
                    return
                }
                let result = Result {
                    try document.data(as: User.self)
                }
                switch result {
                case .success(let user):
                    if let user = user {
                        self.getFilteredGroups(user: user)
                    } else {
                        Alert.displayAlertDialog(on: self.vc, title: "User Not Found", message: "Could not found the user")
                    }
                case .failure(let error):
                    Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                }
        }
    }
    
    func getFilteredGroups(user: User){
        if user.selectedGroupsList.isEmpty{
            print("There was the problem")
            return
        }
        db.collection(K.FireStore.groupsCollection)
            .whereField("groupName", in: user.selectedGroupsList)
            .getDocuments() { querySnapshot, error in
                print(user.selectedGroupsList)
                self.groupList = []
                if let error = error {
                    Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                }else{
                    for document in querySnapshot!.documents {
                        let result = Result {
                            try document.data(as: Group.self)
                        }
                        switch result {
                        case .success(let group):
                            if let group = group {
                                self.groupList.append(group)
                            } else {
                                Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(String(describing: error))")
                            }
                        case .failure(let error):
                            Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                        }
                    }
                    self.callback?.onFinish(group: self.groupList)
                }
        }
        
    }
    
    //MARK: - FETCH ALL GROUP ORDERED BY GROUP NAME
    func getAllGroups(){
        db.collection(K.FireStore.groupsCollection)
            .order(by: "groupName",descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                self.groupList = []
                if let error = error {
                    Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let result = Result {
                            try document.data(as: Group.self)
                        }
                        switch result {
                        case .success(let group):
                            if let group = group {
                                self.groupList.append(group)
                            } else {
                                Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(String(describing: error))")
                            }
                        case .failure(let error):
                            Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                        }
                    }
                    self.callback?.onFinish(group: self.groupList)                }
        }
    }
    
    //MARK: - APPEND GROUP TO USER
    func appendGroupToUser(user: User, group: Group){
        db.collection(K.FireStore.usersCollection)
            .document(user.userEmail).updateData(["selectedGroupsList": FieldValue.arrayUnion([group.groupName])])
    }
    
    
    
    //MARK: - QUERY GET ALL GROUPS BY NAME
    func getGroupFilteredByName(name: String) {
        db.collection(K.FireStore.usersCollection)
            .whereField("groupName", isGreaterThanOrEqualTo: name)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                }else {
                    if let snapshotDocument = querySnapshot?.documents {
                        for document in snapshotDocument {
                            let result = Result {
                                try document.data(as: Group.self)
                            }
                            switch result {
                            case .success(let group):
                                if let group = group {
                                    self.groupList.append(group)
                                } else {
                                    Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(String(describing: error))")
                                }
                            case .failure(let error):
                                Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                            }
                        }
                        self.callback?.onFinish(group: self.groupList)
                    }
                }
        }
    }
    
}
