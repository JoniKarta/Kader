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

class FirebaseFirestoreItemService {
    let db = Firestore.firestore()
    let callback : ItemCallback?
    var itemList = [TodoItem]()
    var vc : UIViewController
    init(vc: UIViewController, callback: ItemCallback){
        self.callback = callback
        self.vc = vc
    }
    
    func setTodoItem(group: Group, todoItem: TodoItem){
        db.collection(K.FireStore.groupsCollection)
            .whereField("uuid", isEqualTo: group.getUUID())
            .getDocuments() {(documentSnapshot, err) in
                if let err = err {
                    Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(err)")
                } else {
                    for document in documentSnapshot!.documents {
                        let docRef = document.reference
                        do {
                            try docRef.collection(K.FireStore.tasksCollection)
                                .document(todoItem.task).setData(from : todoItem)
                            self.getAllTodoItems(group: group)
                        }catch let error {
                            Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                        }
                    }
                }
        }
    }
    
        
    func getAllTodoItems(group: Group) {
        db.collection(K.FireStore.groupsCollection).whereField("uuid", isEqualTo: group.getUUID()).getDocuments() { (documentSnapshot, err) in
            if let err = err {
                Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(err)")
                return
            }
            self.itemList = []
            for document in documentSnapshot!.documents {
                document.reference.collection(K.FireStore.tasksCollection).getDocuments() {
                    (querySnapshot, err) in
                    if let err = err {
                        Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(err)")
                        return
                    }
                    for document in querySnapshot!.documents {
                        let result = Result {
                            try document.data(as: TodoItem.self)
                        }
                        switch result {
                        case .success(let todoItem):
                            if let item = todoItem {
                                self.itemList.append(item)
                            }
                        case .failure(let error):
                            Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                            return
                        }
                    }
                    self.callback?.onFinish(itemList: self.itemList)
                }
            }
        }
    }
    
    
    func setItemDone(user: User, group: Group, todoItem: TodoItem) {
        db.collection(K.FireStore.groupsCollection).whereField("uuid", isEqualTo: group.getUUID()).getDocuments() { (documentSnapshot, err) in
            if let err = err {
                Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(err)")
                return
            }
            for document in documentSnapshot!.documents {
                document.reference.collection(K.FireStore.tasksCollection).document(todoItem.task).updateData(["isDone" : true,"completedBy" : user.userEmail])
                self.getAllTodoItems(group: group)
            }
        }
    }
}






