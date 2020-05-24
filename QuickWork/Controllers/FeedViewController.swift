//
//  FeedViewController.swift
//  QuickWork
//
//  Created by Christopher Cooper on 5/23/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var tasks = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getTasks()
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addListingButton(_ sender: Any) {
        self.performSegue(withIdentifier: Segues.addListing, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.details, for: indexPath) as! DetailsCell
        let task = tasks[indexPath.row]
        
        cell.listingNameLabel.text = task["name"] as? String
        cell.detailsLabel.text = task["description"] as? String
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender is UITableViewCell{
            let cell = sender as! UITableViewCell
            
            
            let indexPath = tableView.indexPath(for: cell)!
            let details = tasks[indexPath.row]
            
            
            let detailsViewController = segue.destination as! DetailsViewController
            detailsViewController.details = details
            
            tableView.deselectRow(at: indexPath, animated: true)
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
    
    func getTasks() {
        let query = PFQuery(className: "Tasks")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.includeKey("user")
        query.findObjectsInBackground { (tasks, error) in
            if let tasks = tasks {
                self.tasks = tasks
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
}







