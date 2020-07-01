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

class FirebaseFirestoreItemService {
    let db = Firestore.firestore()
    let callback : ItemCallback?
    var taskList = [TodoItem]()
    var vc : UIViewController
    init(vc: UIViewController, callback: ItemCallback){
        self.callback = callback
        self.vc = vc
    }
    
    // MARK: - ADD NEW TASK
    func addTask(group: Group, todoItem: TodoItem){
        db.collection(K.FireStore.groupsCollection)
            .whereField(K.GroupFields.groupUUID, isEqualTo: group.getUUID())
            .getDocuments() {(documentSnapshot, err) in
                if let err = err {
                    Alert.displayAlertDialog(on: self.vc, title: "Error Occurred", message: "\(err)")
                } else {
                    for document in documentSnapshot!.documents {
                        let docRef = document.reference
                        do {
                            try docRef.collection(K.FireStore.tasksCollection)
                                .document(todoItem.task).setData(from : todoItem)
                            self.getAllTasks(group: group)
                        }catch let error {
                            Alert.displayAlertDialog(on: self.vc, title: "Error Occurred", message: "\(error)")
                        }
                    }
                }
        }
    }
    
      //MARK: - GET ALL TASKS
    func getAllTasks(group: Group) {
        db.collection(K.FireStore.groupsCollection).whereField("uuid", isEqualTo: group.getUUID()).getDocuments() { (documentSnapshot, err) in
            if let err = err {
                Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(err)")
                return
            }
            self.taskList = []
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
                                self.taskList.append(item)
                            }
                        case .failure(let error):
                            Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                            return
                        }
                    }
                    self.callback?.onFinish(itemList: self.taskList)
                }
            }
        }
    }
    
    //MARK: - UPDATE TASK STATE
    func updateTaskState(user: User, group: Group, todoItem: TodoItem) {
        db.collection(K.FireStore.groupsCollection).whereField("uuid", isEqualTo: group.getUUID()).getDocuments() { (documentSnapshot, err) in
            if let err = err {
                Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(err)")
                return
            }
            for document in documentSnapshot!.documents {
                document.reference.collection(K.FireStore.tasksCollection).document(todoItem.task).updateData(["isDone" : true,"completedBy" : user.userEmail])
                self.getAllTasks(group: group)
            }
        }
    }
    
    
    
    // MARK: - GET ALL TASKS FILTERED BY NAME
    func getTasksFilteredByName(group: Group, name: String) {
         db.collection(K.FireStore.groupsCollection).whereField("uuid", isEqualTo: group.getUUID()).getDocuments() { (documentSnapshot, err) in
                   if let err = err {
                       Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(err)")
                       return
                   }
            let document = documentSnapshot!.documents.first
            document?.reference.collection(K.FireStore.tasksCollection)
               .whereField("task", isGreaterThanOrEqualTo: name)
               .getDocuments() { (querySnapshot, error) in
                   self.taskList = []
                   if let error = error {
                       Alert.displayAlertDialog(on: self.vc, title: "Error Occurred", message: "\(error)")
                   }else {
                       if let snapshotDocument = querySnapshot?.documents {
                           for document in snapshotDocument {
                               self.tasksResultHandler(document: document)
                           }
                        self.callback?.onFinish(itemList: self.taskList)
                       }
                   }
           }
       }
    }
    
    // MARK: - TASKS RESULT HANDLER
    func tasksResultHandler(document: QueryDocumentSnapshot) {
        let result = Result {
            try document.data(as: TodoItem.self)
        }
        switch result {
        case .success(let item):
            if let item = item {
                self.taskList.append(item)
            }
        case .failure(let error):
            Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
        }
    }
        
}






