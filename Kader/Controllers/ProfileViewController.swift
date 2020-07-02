//
//  ViewController.swift
//  Kader
//
//  Created by user165579 on 6/16/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profile_VIEW_topView: UIView!
    @IBOutlet weak var imageCamera: UIImageView!
    
    @IBOutlet weak var profile_VIEW_bottomView: UIView!
    
    @IBOutlet weak var profile_LBL_email: UILabel!
   
    @IBOutlet weak var profile_TLBL_userName: UILabel!
    @IBOutlet weak var profile_LBL_noGroupEnrolled: UILabel!
    
    
    var fbProfileService: FirebaseFirestoreProfileService!
    var fbUserService: FirebaseFirestoreUserService!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbProfileService = FirebaseFirestoreProfileService(vc: self, callback: self)
        fbUserService = FirebaseFirestoreUserService(vc: self, callback: self)
        setTopViewConfiguration()
        fbProfileService.downloadImageFromStorage(documentId: user.userEmail)
        fbUserService.getUser(userEmail: user.userEmail)
        ImageUtility.circleImage(imageView: imageCamera)
    }
    
    @IBAction func profile_BTN_changeUserName(_ sender: UIButton) {
        var newTaskTextField = UITextField()
            let changeUserNameDialog = UIAlertController(title: "Set Your New Name", message:"", preferredStyle: UIAlertController.Style.alert)
            
            let action = UIAlertAction(title: "OK" , style: .default) { (action) in
                let userName = newTaskTextField.text!
                self.fbUserService.setNewUserName(user: self.user, newUserName: userName)
            }
            
            // Set the placeholder of the text and get the text from it
            changeUserNameDialog.addTextField {
                (alertTextField) in alertTextField.placeholder = "Type your new user name"
                newTaskTextField = alertTextField
            }
            
            changeUserNameDialog.addAction(action)
            changeUserNameDialog.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            present(changeUserNameDialog, animated: true, completion:nil)
        }
    
    
    func setTopViewConfiguration() {
        profile_VIEW_topView.layer.borderWidth = 5
        profile_VIEW_bottomView.layer.borderWidth = 5
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBAction func takePhoto(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker:
        UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            fbProfileService.uploadImage(user: user, uploadImage: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: ProfileCallback {
    func onFinishDownloadUrlWithIndex(url: String, index: Int) {
        //
    }
    
    func onFinishDownloadUrl(url: String) {
        let downloadedUrl = URL(string: url)
        imageCamera.kf.setImage(with: downloadedUrl)
    }
}

extension ProfileViewController: UserCallback {
    func onFinish(user: User) {
        DispatchQueue.main.async {
            self.profile_LBL_email.text = self.user.userEmail
            self.profile_TLBL_userName.text = user.userName
            self.profile_LBL_noGroupEnrolled.text = String(user.groupListId.count)
            
        }
    }
    
    
}
