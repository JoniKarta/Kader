//
//  ViewController.swift
//  Kader
//
//  Created by user165579 on 6/16/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var profile_VIEW_topView: UIView!
    @IBOutlet weak var imageCamera: UIImageView!
    @IBOutlet weak var profile_VIEW_bottomView: UIView!
    
    @IBOutlet weak var profile_LBL_email: UILabel!
    @IBOutlet weak var profile_LBL_noGroupManaged: UILabel!
    @IBOutlet weak var profile_TLBL_userName: UITextField!
    @IBOutlet weak var profile_LBL_noGroupEnrolled: UILabel!
    
    
    var fbProfileService: FirebaseFirestoreProfileService!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbProfileService = FirebaseFirestoreProfileService(vc: self, callback: self)
        setTopViewConfiguration()
    
        setCircleImage()
       // Do any additional setup after loading the view.
    }
    
    func setTopViewConfiguration() {
        profile_VIEW_topView.layer.borderWidth = 5
        profile_VIEW_bottomView.layer.borderWidth = 5
    }

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
            //imageCamera.image = pickedImage
            fbProfileService.uploadImage(user: user, uploadImage: imageCamera)
            //fbProfileService.downloadImageFromStorage(user: user)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setCircleImage() {
        imageCamera.contentMode = .scaleToFill
        imageCamera.layer.cornerRadius = imageCamera.frame.size.width / 2
        imageCamera.clipsToBounds = true
        imageCamera.layer.borderColor = UIColor.white.cgColor
        imageCamera.layer.borderWidth = 4
    }
}

extension ViewController: ProfileCallback {
    func onFinish(url: String) {
        print("============== DOWNLOADED URL ==================")
        print(url)
    }
    
    
}
