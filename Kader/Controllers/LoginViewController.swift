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
    let db = Firestore.firestore()
    var user: User!
    var fbUserService: FirebaseFirestoreUserService!
    @IBOutlet weak var login_TEXTVIEW_email: UITextField!
    @IBOutlet weak var login_TEXTVIEW_password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        fbUserService = FirebaseFirestoreUserService(vc: self, callback: self)
    }
    
    // MARK: - Login using firebase
    
    @IBAction func login_BTN_log(_ sender: UIButton) {
        if let email = login_TEXTVIEW_email.text, let password = login_TEXTVIEW_password.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    self.displayAlertDialog(title: "Error", message: err.localizedDescription)
                }else{
                    self.fbUserService.getUser(userEmail: email)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.loginSegue {
            let destinationController = segue.destination as! MyGroupTableViewController
            destinationController.user = self.user
        }
    }
    func displayAlertDialog(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion:nil)
    }
}

extension LoginViewController: UserCallback {
    func onFinish(user: User) {
        self.user = user
        self.performSegue(withIdentifier: K.loginSegue, sender: self)
    }
    
    
}
