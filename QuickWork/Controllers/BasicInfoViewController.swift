//
//  BasicInfoViewController.swift
//  QuickWork
//
//  Created by Joshua Chan on 5/22/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import Parse

class BasicInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        emailField.delegate = self
        phoneNumberField.delegate = self
        
        errorLabel.text = ""
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
    @IBAction func onDone(_ sender: Any) {
        if let email = emailField.text, let number = phoneNumberField.text, let name = nameField.text {
        
            
            PFUser.current()?.setObject(email, forKey: "email")
            PFUser.current()?.setObject(number, forKey: "number")
            PFUser.current()?.setObject(name, forKey: "name")
            PFUser.current()?.saveInBackground()
            
            self.performSegue(withIdentifier: Segues.personalInfo, sender: nil)
        } else {
            errorLabel.text = "All sections have to be filled out"
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
