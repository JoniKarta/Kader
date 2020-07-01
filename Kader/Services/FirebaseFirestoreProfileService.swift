//
//  FirebaseFirestoreProfileService.swift
//  Kader
//
//  Created by user165579 on 6/23/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation


//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseFirestoreProfileService {
    let db = Firestore.firestore()
    let callback : ProfileCallback?
    let imageStorageReference = Storage.storage()
    
    var vc: UIViewController
    init(vc: UIViewController, callback: ProfileCallback){
        self.callback = callback
        self.vc = vc
    }

    //MARK: - UPLOAD IMAGE TO STORAGE
    
    func uploadImage(user: User, uploadImage: UIImage) {
        
        guard let data = uploadImage.jpegData(compressionQuality: 1.0) else {
            Alert.displayAlertDialog(on: self.vc, title: "Error", message: "Something went wrong..")
            return
        }
        
        let reference = imageStorageReference.reference().child(K.FireStore.userProfileImage).child(user.userEmail)
        
        reference.putData(data, metadata: nil) {(metadata, error ) in
            if let err = error {
                print("\(err)")
                return
            }
            reference.downloadURL(completion: {(url, error) in
                if let err = error {
                    print("\(err)")
                    return
                }
                
                guard let url = url else {
                    print("error")
                    return
                }
                let dataReference = Firestore.firestore()
                    .collection(K.FireStore.userProfileImage)
                    .document(user.userEmail)
                
                let data = ["imageUrl" : url.absoluteString]
                
                dataReference.setData(data, completion: {(error) in
                    if let err = error {
                        print("e\(err)")
                        return
                    }
                    self.callback?.onFinishDownloadUrl(url: url.absoluteString)
                })
            })
        }
    }
  
    //MARK: - DOWNLOAD IAMGE FROM STORAGE
    func downloadImageFromStorage(documentId: String) {
        let docRef = Firestore.firestore()
            .collection(K.FireStore.userProfileImage)
            .document(documentId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists  {
                let url = document.get("imageUrl") as! String
                self.callback?.onFinishDownloadUrl(url: url)
            }
        }
    }
    
    func downloadImageFromStorage(documentId: String, index: Int) {
        let docRef = Firestore.firestore()
            .collection(K.FireStore.userProfileImage)
            .document(documentId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists  {
                let url = document.get("imageUrl") as! String
                self.callback?.onFinishDownloadUrlWithIndex(url: url, index: index)
            }
        }
    }
    
    
}
