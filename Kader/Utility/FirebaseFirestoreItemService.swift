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
    
    func setTodoItem(newGroup: Group, todoItem: TodoItem){
        do{
            try  db.collection(K.FireStore.groupsCollection)
                .document(newGroup.groupName)
                .collection(K.FireStore.tasksCollection)
                .document().setData(from: todoItem)
        }catch let error {
            Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
        }
    }
    
    func getAllTodoItem(group: Group){
        print("Get All Todo Item gets called")
        db.collection(K.FireStore.groupsCollection)
            .document(group.groupName)
            .collection(K.FireStore.tasksCollection)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let result = Result {
                            try document.data(as: TodoItem.self)
                        }
                        switch result {
                        case .success(let todoItem):
                            if let item = todoItem {
                                self.itemList.append(item)
                            } else {
                                Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(String(describing: err))")
                            }
                        case .failure(let error):
                            Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                        }
                    }
                    self.callback?.onFinish(itemList: self.itemList)
                }
        }
    }
}
