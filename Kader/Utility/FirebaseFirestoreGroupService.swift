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

class FBGroupService {
    let db = Firestore.firestore()
    let callback : GroupCallback?
    var groupList : [Group] = [Group]()
    let decoder = JSONDecoder()
    
    init(callback: GroupCallback){
        self.callback = callback
    }
    func setGroup(newGroup: Group){
        let docRef =  db.collection(K.FireStore.groupsCollection).document(newGroup.groupName)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("This document is already exists")
            } else {
                docRef.setData(["groupName": newGroup.groupName, "creator":    newGroup.getCreator()])
            }
            
        }
    }
    
    func getFilteredGroups(groupList: [String]){
        let docsRef = db.collection(K.FireStore.groupsCollection)
        docsRef.whereField("groupName", in: groupList)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error retreiving collection: \(error)")
                }else{
                    
                    for document in querySnapshot!.documents {
                        let result = Result {
                            try document.data(as: Group.self)
                        }
                        switch result {
                        case .success(let group):
                            if let group = group {
                                self.groupList.append(group)
                                print("Group: \(group)")
                            } else {
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            print("Error decoding city: \(error)")
                        }
                    }
                    self.callback?.onFinish(group: self.groupList)
                }
        }
        
    }
    
    func getAllGroups(groupList: [Group]){
        db.collection(K.FireStore.groupsCollection).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    func setTodoItem(newGroup: Group, todoItem: TodoItem){
        do{
            try  db.collection(K.FireStore.groupsCollection)
                .document(newGroup.groupName)
                .collection(K.FireStore.tasksCollection)
                .document().setData(from: todoItem)
        }catch let error {
            print("\(error)")
        }
    }
    
    func getAllTodoItem(group: Group){
        db.collection(K.FireStore.groupsCollection)
            .document(group.groupName)
            .collection(K.FireStore.tasksCollection)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
        }
    
    
  
    
    
    
    func getAllTodoItemsFromGroup(group: Group){
        db.collection(K.FireStore.groupsCollection)
            .document(group.groupName)
            .collection(K.FireStore.tasksCollection).getDocuments() {
                (querySnapshot, err) in
                if let err = err {
                    print("Error occurred \(err)")
                }else{
                    for document in querySnapshot!.documents {
                        print(document.data())
                    }
                }
        }
    }
    
    
    func appendGroupToUser(user: User, group: Group){
        db.collection(K.FireStore.usersCollection)
            .document(user.userEmail).updateData(["groupList": FieldValue.arrayUnion([group.groupName])])
        
    }
    
}