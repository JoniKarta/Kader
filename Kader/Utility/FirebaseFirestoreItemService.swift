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

protocol ItemCallback {
    func onFinish(itemList: [TodoItem])
}

class FBItemService {
    let db = Firestore.firestore()
    let callback : ItemCallback?
    
    init(callback: ItemCallback){
        self.callback = callback
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
}
