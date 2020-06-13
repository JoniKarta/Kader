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

class FBUserService {
    let db = Firestore.firestore()
    let callback : UserCallback?
    init(callback: UserCallback){
        self.callback = callback
    }
    
    func setUser(user: User) {
        do{
            try db.collection(K.FireStore.usersCollection)
                .document(user.userEmail)
                .setData(from: user)
            callback?.onFinish(user: user)
        }catch let error {
            print("\(error)")
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
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding item: \(error)")
            }
        }
    }
    
    func onUserGroupsChangedListener(userEmail: String) {
    let docRef = db.collection(K.FireStore.usersCollection).document(userEmail)
    
        docRef.addSnapshotListener {(document, error ) in
        let result = Result {
            try document?.data(as: User.self)
        }
        switch result {
        case .success(let user):
            if let user = user {
                self.callback?.onFinish(user: user)
            } else {
                print("Document does not exist")
            }
        case .failure(let error):
            print("Error decoding item: \(error)")
        }
    }
        
    }
    
}
