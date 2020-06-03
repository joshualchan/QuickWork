//
//  LoginViewController.swift
//  QuickWork
//
//  Created by Madison Wong on 5/23/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
 
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.text = ""
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        if let username = usernameField.text, let password = passwordField.text {
            PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: Segues.signIn, sender: nil)
                } else {
                    self.errorLabel.text = "Error: \(error!.localizedDescription)"
                }
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        self.performSegue(withIdentifier: "makeAccountSegue", sender: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
