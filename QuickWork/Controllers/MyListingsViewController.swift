//
//  MyListingsViewController.swift
//  QuickWork
//
//  Created by Christopher Cooper on 5/23/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import Parse

class MyListingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var myListings = [PFObject]()
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setProfile()
        roundProfile()
        
        getTasks()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getTasks), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        roundProfile()
        setProfile()
        getTasks()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myListings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.myListings, for: indexPath) as! MyListingCell
        let listing = myListings[indexPath.row]
        
        cell.myListingNameLabel.text = listing["name"] as? String
        cell.myDetailsLabel.text = listing["description"] as? String
        
        
        return cell
    }
    
    @objc func getTasks() {
        let query = PFQuery(className: "Tasks")
        query.addDescendingOrder("createdAt")
        //query.limit = 20
        query.whereKey("user", equalTo: PFUser.current()!)
        query.includeKey("user")
        query.findObjectsInBackground { (tasks, error) in
            if let tasks = tasks {
                self.myListings = tasks
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
        refresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender is UITableViewCell{
            let cell = sender as! UITableViewCell
            
            
            let indexPath = tableView.indexPath(for: cell)!
            let details = myListings[indexPath.row]
            
            
            let detailsViewController = segue.destination as! DetailsViewController
            detailsViewController.details = details
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    //next two functions are for pull down to refresh
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    func refresh() {
        run(after: 2) {
           self.refreshControl.endRefreshing()
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
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = loginViewController
    }
    
    func roundProfile() {

        profilePicture.layer.masksToBounds = false
       
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.clipsToBounds = true
    }
    
    func setProfile() {
        
        if let user = PFUser.current() {
            nameLabel.text = user["name"] as? String
            emailLabel.text = user["email"] as? String
            phoneNumberLabel.text = user["number"] as? String
            self.navigationItem.title = user["username"] as? String
            if let imageFile = user["picture"] as? PFFileObject {
                if let urlString = imageFile.url {
                    let url = URL(string: urlString)!
                    profilePicture.af.setImage(withURL: url)
                }
            }
        }
    }
    
}
