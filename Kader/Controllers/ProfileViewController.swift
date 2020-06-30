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
    @IBOutlet weak var profile_LBL_noGroupManaged: UILabel!
    
    @IBOutlet weak var profile_TLBL_userName: UILabel!
    @IBOutlet weak var profile_LBL_noGroupEnrolled: UILabel!
    
    
    var fbProfileService: FirebaseFirestoreProfileService!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbProfileService = FirebaseFirestoreProfileService(vc: self, callback: self)
        setTopViewConfiguration()
        fbProfileService.downloadImageFromStorage(user: user)
        setCircleImage()
        setUserProfileDetails()
    }
    
    func setUserProfileDetails() {
        profile_LBL_email.text = user.userEmail
        profile_TLBL_userName.text = user.userName
        profile_LBL_noGroupEnrolled.text = String(user.groupListId.count)
    }
    
    func setTopViewConfiguration() {
        profile_VIEW_topView.layer.borderWidth = 5
        profile_VIEW_bottomView.layer.borderWidth = 5
    }
    
    func setCircleImage() {
        imageCamera.contentMode = .scaleToFill
        imageCamera.layer.cornerRadius = imageCamera.frame.size.width / 2
        imageCamera.clipsToBounds = true
        imageCamera.layer.borderColor = UIColor.white.cgColor
        imageCamera.layer.borderWidth = 4
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
            setCircleImage()
            fbProfileService.uploadImage(user: user, uploadImage: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
extension ProfileViewController: ProfileCallback {
    func onFinish(url: String) {
        let downloadedUrl = URL(string: url)
        imageCamera.kf.setImage(with: downloadedUrl)
    }
    
    
}
