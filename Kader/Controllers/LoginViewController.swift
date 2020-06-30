//
//  LoginViewController.swift
//  Kader
//
//  Created by user165579 on 6/11/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var login_TEXTVIEW_email: UITextField!
    @IBOutlet weak var login_TEXTVIEW_password: UITextField!
    
    // Firebase user service utility
    var fbUserService: FirebaseFirestoreUserService!
    
    // Hold the current user for segue
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoard()
        fbUserService = FirebaseFirestoreUserService(vc: self, callback: self)
    }
    
    // MARK: - LOGIN
    
    @IBAction func login_BTN_log(_ sender: UIButton) {
        if let email = login_TEXTVIEW_email.text, let password = login_TEXTVIEW_password.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    Alert.displayAlertDialog(on: self, title: "Error", message: err.localizedDescription)
                }else{
                    self.fbUserService.getUser(userEmail: email)
                }
            }
        }
    }
    
    
    // MARK: - PREPARE FOR SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.loginToHome {
            let destinationController = segue.destination as! MyGroupTableViewController
            destinationController.user = self.user
        }
    }
    
}

// MARK: - USER CALLBACK
extension LoginViewController: UserCallback {
    func onFinish(user: User) {
        self.user = user
        self.performSegue(withIdentifier: K.Segue.loginToHome, sender: self)
    }
}

//MARK: - HANDLE HIDE KEYBOARD
extension LoginViewController {
    func hideKeyBoard() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyBoard))
        
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
    
}
