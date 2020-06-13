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
    
    func getFilteredGroups(selectedGroupList: [String]){
        let docsRef = db.collection(K.FireStore.groupsCollection)
        docsRef.whereField("groupName", in: selectedGroupList)
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
                            } else {
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            print("Error decoding group: \(error)")
                        }
                    }
                    self.callback?.onFinish(group: self.groupList)
                }
        }
        
    }
    
    func getAllGroups(){
        db.collection(K.FireStore.groupsCollection)
            .order(by: "groupName",descending: true)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
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
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            print("Error decoding group: \(error)")
                        }
                    }
                    self.callback?.onFinish(group: self.groupList)                }
        }
    }
    
    func appendGroupToUser(user: User, group: Group){
        db.collection(K.FireStore.usersCollection)
            .document(user.userEmail).updateData(["groupList": FieldValue.arrayUnion([group.groupName])])
    }
    
    func getGroupFilteredByName(name: String) {
        db.collection(K.FireStore.usersCollection)
            .whereField("groupName", isGreaterThanOrEqualTo: name)
            .addSnapshotListener { (querySnapshot, error) in
                if let err = error {
                    print("There was an error \(err)")
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
                                    print("Document does not exist")
                                }
                            case .failure(let error):
                                print("Error decoding group: \(error)")
                            }
                        }
                        self.callback?.onFinish(group: self.groupList)
                    }
                }
        }
    }
}
