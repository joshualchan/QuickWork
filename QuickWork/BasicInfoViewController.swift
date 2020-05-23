//
//  BasicInfoViewController.swift
//  QuickWork
//
//  Created by Joshua Chan on 5/22/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import Parse

class BasicInfoViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onDone(_ sender: Any) {
        let user = PFUser()
        let email = emailField.text
        let number = phoneNumberField.text
        
        if number != nil {
            if email != nil {
                self.performSegue(withIdentifier: "personalInfoSegue", sender: nil)
            }
        }
        user["phone"] = number
        user["email"] = email
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
