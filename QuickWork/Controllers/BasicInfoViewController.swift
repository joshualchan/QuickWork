//
//  BasicInfoViewController.swift
//  QuickWork
//
//  Created by Madison Wong on 5/23/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import Parse

class BasicInfoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
 
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
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
        if emailField.text != "" && phoneNumberField.text != "" && nameField.text != "" {
            let email = emailField.text!
            let number = phoneNumberField.text!
            let name = nameField.text!
            PFUser.current()?.setObject(email, forKey: "email")
            PFUser.current()?.setObject(number, forKey: "number")
            PFUser.current()?.setObject(name, forKey: "name")
            if let imageData = profilePicture.image!.pngData() {
            
                if let file = PFFileObject(name: "image.png", data: imageData) {

                    PFUser.current()?.setObject(file, forKey: "picture")
                }
            }
            
            
            PFUser.current()?.saveInBackground(block: { (success, error) in
                if let error = error {
                    self.errorLabel.text = error.localizedDescription
                } else {
                    self.performSegue(withIdentifier: Segues.personalInfo, sender: nil)
                }
            })

        } else {
            errorLabel.text = "All sections have to be filled out"
        }
    }
    
    
    @IBAction func onPicture(_ sender: Any) {
        let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
           
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
            } else {
                picker.sourceType = .photoLibrary
            }
           
            present(picker, animated: true, completion: nil)
        }

        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.editedImage] as! UIImage
            
            let size = CGSize(width: 300, height: 300)
            let scaledImage = image.af.imageScaled(to: size)
            
            profilePicture.image = scaledImage
            dismiss(animated: true, completion: nil)
        }
    

}
