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
        
        if let email = emailField.text {
            PFUser.current()?.setObject(email, forKey: "email")
        }
        if let number = phoneNumberField.text {
            PFUser.current()?.setObject(number, forKey: "number")
        }
        
        PFUser.current()?.saveInBackground()
        
        self.performSegue(withIdentifier: Segues.personalInfo, sender: nil)
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
