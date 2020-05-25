//
//  AddListingViewController.swift
//  QuickWork
//
//  Created by Christopher Cooper on 5/23/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class AddListingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var taskImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        if emptyText() == false {
            let object = PFObject(className: "Tasks")
            
            object["name"] = nameTextField.text!
            object["description"] = descriptionTextField.text!
            object["city"] = cityTextField.text
            
            if let imageData = taskImage.image!.pngData() {
            
                let file = PFFileObject(name: "image.png", data: imageData)

                object["image"] = file
            }
            object["user"] = PFUser.current()
            
            object.saveInBackground { (success, error) in
                if error != nil {
                    print("Could not be saved, \(error!)")
                } else {
                    print("Saved successfully")
                }
            }
            
            dismiss(animated: true, completion: nil)
        } else {
            errorLabel.text = "Please fill out all sections."
        }
            
        
    }
    
    
    @IBAction func onPicture(_ sender: Any) {
        print("in")
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
        
        taskImage.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    
    
    func emptyText() -> Bool {
        if nameTextField.text == "" || descriptionTextField.text == "" || cityTextField.text == ""  {
            return true
        }
        return false
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
