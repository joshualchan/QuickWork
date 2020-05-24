//
//  DetailsViewController.swift
//  QuickWork
//
//  Created by Christopher Cooper on 5/23/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class DetailsViewController: UIViewController {

    
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var details = PFObject(className: "Tasks")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = details["description"] as? String
        taskNameLabel.text = details["name"] as? String
        cityLabel.text = details["city"] as? String
        let user = details["user"] as? PFUser
        
        if let imageFile = details["image"] as? PFFileObject {
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            taskImage.af.setImage(withURL: url)
        }
        
        
        nameLabel.text = user?["name"] as? String
        
        // Do any additional setup after loading the view.
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
