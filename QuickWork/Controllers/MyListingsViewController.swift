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
    var myListings = [PFObject]()
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getTasks()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getTasks), for: .valueChanged)
        // Do any additional setup after loading the view.
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
        //refresh()
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

}
