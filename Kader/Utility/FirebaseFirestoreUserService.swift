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

protocol UserCallback {
    func onFinish(user: User)
}

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
            Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
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
                    Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(String(describing: error))")
                }
            case .failure(let error):
                Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
            }
        }
    }

    
}
