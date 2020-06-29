//
//  FirebaseChatService.swift
//  Kader
//
//  Created by user165579 on 6/17/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


class FirebaseFirestoreChatService {
    let db = Firestore.firestore()
    let callback : ChatCallback?
    var vc: UIViewController
    var messageList: [Message] = [Message]()
    init(vc: UIViewController, callback: ChatCallback){
        self.callback = callback
        self.vc = vc
    }
    
    //MARK: - WRITE NEW MESSAGE
    func writeNewMessage(group: Group, message: Message) {
        do{
            try db.collection(K.FireStore.chatCollection)
                       .document(group.getUUID())
                       .collection(K.FireStore.chatMessageCollection)
                       .document()
                   .setData(from: message)
        } catch let error {
            print(error)
        }
       
    }
    
    //MARK: - READ ALL MESSAGE BY DATE
    
    func readMessages(group: Group){
        db.collection(K.FireStore.chatCollection)
            .document(group.getUUID())
            .collection(K.FireStore.chatMessageCollection).order(by: "dateIntervalTime")
            .addSnapshotListener 	{ (querySnapshot, error) in
                self.messageList = []
                if let err = error {
                    print(err)
                }else {
                    if let snapshotDocument = querySnapshot?.documents {
                        for doc in snapshotDocument {
                            let result = Result {
                                try doc.data(as: Message.self)
                            }
                            switch result {
                            case .success(let message):
                                if let message = message {
                                    self.messageList.append(message)
                                } else {
                                    Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(String(describing: error))")
                                }
                            case .failure(let error):
                                Alert.displayAlertDialog(on: self.vc, title: "Fatal Error", message: "\(error)")
                            }
                        }
                    }
                    self.callback?.onFinish(messageList: self.messageList)
                }
        }
    }
    
    
    
}

