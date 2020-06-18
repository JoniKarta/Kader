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
    func onFinish(user: User, group: [Group])
}

class FirebaseFirestoreGroupService {
    let db = Firestore.firestore()
    let callback : GroupCallback?
    var listener : ListenerRegistration?
    let vc : UIViewController
    var user: User = User()
    var groupList : [Group] = [Group]()
    
    init(vc: UIViewController , callback: GroupCallback){
        self.callback = callback
        self.vc = vc
    }
     
    
    // MARK: - USER GROUP LIST LISTENER
    func onUserGroupListChangeListener(user: User, isGroupFiltered: Bool){
         listener =  db.collection(K.FireStore.usersCollection)
            .document(user.userEmail)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(String(describing: error))")
                    return
                }
                self.userResultHandler(document: document,isGroupFilter: isGroupFiltered)
        }
    }
    
    func getFilteredGroups(user: User){
        if user.groupListId.isEmpty {
            self.groupList = []
            self.callback?.onFinish(user: user, group: self.groupList)
        }else {
            db.collection(K.FireStore.groupsCollection)
                .whereField("uuid", in: user.groupListId)
                
                .getDocuments() { querySnapshot, error in
                    self.groupList = []
                    if let error = error {
                        Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                    }else{
                        for document in querySnapshot!.documents {
                            self.groupResultHandler(document: document)
                        }
                        self.callback?.onFinish(user: user, group: self.groupList)
                    }
            }
            
        }
        
    }
    
    //MARK: - FETCH ALL GROUP ORDERED BY GROUP NAME
    func getAllGroups(user: User){
        db.collection(K.FireStore.groupsCollection)
            .order(by: "groupName").getDocuments() { (querySnapshot, error) in
            self.groupList = []
            if let error = error {
                Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
            } else {
                for document in querySnapshot!.documents {
                    self.groupResultHandler(document: document)
                }
                self.callback?.onFinish(user: user, group: self.groupList)
            }
        }        
    }
    
    
    //MARK: - APPEND GROUP TO USER
    
    func appendGroupToUser(user: User, group: Group){
        db.collection(K.FireStore.usersCollection)
            .document(user.userEmail).updateData(["groupListId": FieldValue.arrayUnion([group.getUUID()])])
                
    }
    
    func setGroup(user: User, newGroup: Group){
         let docRef =  db.collection(K.FireStore.groupsCollection).document()
         docRef.getDocument { (document, error) in
             if let document = document, document.exists {
                 Alert.displayAlertDialog(on: self.vc, title: "Group Already exists", message: "Sorry this group already exists try different name.")
             } else {
                 docRef.setData(["groupName": newGroup.groupName, "creator":    newGroup.getCreator(),"uuid" : newGroup.getUUID()])
                    self.appendGroupToUser(user: user, group: newGroup)
             }
         }
     }
    // Remove group from user
      func removeGroupFromUser(user: User, group: Group){
          db.collection(K.FireStore.usersCollection)
              .document(user.userEmail).updateData(["groupListId": FieldValue.arrayRemove([group.getUUID()])])
      }
    //MARK: - QUERY GET ALL GROUPS BY NAME
    func getGroupFilteredByName(name: String) {
        db.collection(K.FireStore.groupsCollection)
            .whereField("groupName", isGreaterThanOrEqualTo: name)
            .getDocuments() { (querySnapshot, error) in
                self.groupList = []
                if let error = error {
                    Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                }else {
                    if let snapshotDocument = querySnapshot?.documents {
                        for document in snapshotDocument {
                            self.groupResultHandler(document: document)
                        }
                        self.callback?.onFinish(user: self.user, group: self.groupList)
                    }
                }
        }
    }
    
    //MARK:- RESULTS HANDLER
    
    func groupResultHandler(document: QueryDocumentSnapshot) {
        let result = Result {
            try document.data(as: Group.self)
        }
        switch result {
        case .success(let group):
            if let group = group {
                self.groupList.append(group)
            }
        case .failure(let error):
            Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
        }
    }
    
    func userResultHandler(document: DocumentSnapshot, isGroupFilter: Bool){
        let result = Result {
            try document.data(as: User.self)
        }
        switch result {
        case .success(let user):
            if let user = user {
                if isGroupFilter {
                    self.getFilteredGroups(user: user)
                }else {
                    self.getAllGroups(user: user)
                }
            } else {
                Alert.displayAlertDialog(on: self.vc, title: "User Not Found", message: "Could not found the user")
            }
        case .failure(let error):
            Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
        }
        
    }
    
    
}