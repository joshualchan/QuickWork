//
//  SignUpViewController.swift
//  QuickWork
//
//  Created by Madison Wong on 6/2/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onDone(_ sender: Any) {
        if let username = usernameField.text, let password = passwordField.text {
            let user = PFUser()
            user.username = username
            user.password = password
            user.signUpInBackground { (success, error) in
                if success {
                    self.performSegue(withIdentifier: Segues.signUp, sender: nil)
                } else {
                    self.errorLabel.text = "Error: \(error!.localizedDescription)"
                }
            }
        }
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
