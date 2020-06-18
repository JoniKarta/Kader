//
//  ViewController.swift
//  Kader
//
//  Created by user165579 on 6/16/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageCamera: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            imageCamera.contentMode = .scaleToFill
            imageCamera.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

