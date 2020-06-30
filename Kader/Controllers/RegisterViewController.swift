//
//  RegisterViewController.swift
//  Kader
//
//  Created by user165579 on 6/11/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var register_TEXTVIEW_email: UITextField!
    @IBOutlet weak var register_TEXTVIEW_confirm: UITextField!
    @IBOutlet weak var register_TEXTVIEW_password: UITextField!
    @IBOutlet weak var register_TEXTVIEW_userName: UITextField!
    
    // Firebase user service utility
    var fbUserService: FirebaseFirestoreUserService!
    
    // Hold the current user for segue 
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoard()
        fbUserService = FirebaseFirestoreUserService(vc: self, callback: self)
    }
    
    //MARK: - REGISTER
   
    @IBAction func register_BTN_regiseration(_ sender: UIButton) {
        
        if let email = register_TEXTVIEW_email.text, let password = register_TEXTVIEW_password.text, let confirm = register_TEXTVIEW_confirm.text {
            if password != confirm {
                Alert.displayAlertDialog(on: self, title: "Oops..", message: "Your password dosen't match!")
                return
            }
            if let userName =  register_TEXTVIEW_userName.text {
                if userName.isEmpty {
                    Alert.displayAlertDialog(on: self, title: "Oops", message: "You cannot insert empty name!")
                    return
                }else if !Validator.validName(fullName: register_TEXTVIEW_userName.text!) {
                    Alert.displayAlertDialog(on: self, title: "Oops", message: "Your name should be formatted as firstName seperated with last name")
                    return
                }
            }
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    Alert.displayAlertDialog(on: self, title: "Oops", message: err.localizedDescription)
                }else{
                    self.user = User(userEmail: email, userName: self.register_TEXTVIEW_userName.text!)
                    self.fbUserService.setUser(user: self.user)
                }
            }
        }
    }
    
    //MARK: - PREPARE FOR SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.registerToHome {
            let destinationController = segue.destination as! MyGroupTableViewController
            destinationController.user = self.user
        }
    }
}

//MARK: - USER CALLBACK

extension RegisterViewController: UserCallback {
    func onFinish(user: User) {
        self.performSegue(withIdentifier: K.Segue.registerToHome, sender: self)
    }
}

//MARK: - HANDLE HIDE KEYBOARD

extension RegisterViewController {
    func hideKeyBoard() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyBoard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
    
}
