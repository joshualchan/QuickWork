//
//  EditProfileViewController.swift
//  QuickWork
//
//  Created by Christopher Cooper on 6/1/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = PFUser.current() {
           nameLabel.placeholder = user["name"] as? String
            usernameLabel.placeholder = user["username"] as? String
            phoneNumberLabel.placeholder = user["number"] as? String
            if let imageFile = user["picture"] as? PFFileObject {
                if let urlString = imageFile.url {
                    let url = URL(string: urlString)!
                    profilePicture.af.setImage(withURL: url)
                }
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onConfirm(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
