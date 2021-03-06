//
//  FirebaseFirestoreUserService.swift
//  Kader
//
//  Created by user165579 on 6/13/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseFirestoreUserService {
    let db = Firestore.firestore()
    let callback : UserCallback?
    var vc: UIViewController
    init(vc: UIViewController, callback: UserCallback){
        self.callback = callback
        self.vc = vc
    }
    
    func setUser(user: User) {
        do{
            try db.collection(K.FireStore.usersCollection)
                .document(user.userEmail)
                .setData(from: user)
            callback?.onFinish(user: user)
        }catch let error {
            Alert.displayAlertDialog(on: self.vc, title: "Error occurred", message: "\(error)")
        }
    }
    
    func getUser(userEmail: String){
        let docRef = db.collection(K.FireStore.usersCollection).document(userEmail)
        
        docRef.getDocument() { (document, error ) in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    self.callback?.onFinish(user: user)
                } else {
                    Alert.displayAlertDialog(on: self.vc, title: "Error Occurred", message: "\(String(describing: error))")
                }
            case .failure(let error):
                Alert.displayAlertDialog(on: self.vc, title: "Error Occurred", message: "\(error)")
            }
        }
    }
    func setNewUserName(user: User, newUserName: String) {
        if !Validator.validName(fullName: newUserName){
            Alert.displayAlertDialog(on: self.vc, title: "Invalid User Name",
                                     message: "Name need to be sperated by name and last name")
            return
        }
        Firestore.firestore()
            .collection(K.FireStore.usersCollection)
            .document(user.userEmail).updateData(["userName": newUserName])
        getUser(userEmail: user.userEmail)
    }}
