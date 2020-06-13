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
    let db = Firestore.firestore()
    var fbUserService: FBUserService!
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        fbUserService = FBUserService(callback: self)
    }
    
    //MARK: - Register using firebase
    
    @IBAction func register_BTN_regiseration(_ sender: UIButton) {
        
        if let email = register_TEXTVIEW_email.text, let password = register_TEXTVIEW_password.text, let confirm = register_TEXTVIEW_confirm.text {
            if password != confirm {
                displayAlertDialog(title: "Oops..", message: "Your password dosen't match")
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    self.displayAlertDialog(title: "Error", message: err.localizedDescription)
                }else{
                    self.user = User(userEmail: email)
                    self.fbUserService.setUser(user: self.user)
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.registerSegue {
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
extension RegisterViewController: UserCallback {
    func onFinish(user: User) {
        self.performSegue(withIdentifier: K.registerSegue, sender: self)
    }
}
