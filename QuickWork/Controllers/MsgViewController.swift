//
//  MsgViewController.swift
//  QuickWork
//
//  Created by Joshua Chan on 5/31/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import Parse

class MsgViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var messageList: [PFObject] = []
    var userList: [String] = []
    var tasks = [PFObject]()
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 40;
        retrieveConversations()
       // let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, userInfo: nil, repeats: false)
        let q = PFQuery(className: "User")
        /*
        q.findObjectsInBackground { (s, e) in
            if let s = s {
                print("Successfully retrieved \(s.count) users.")
                //self.messageList.append(s[0])
            }
        }*/
       
        let timer2 = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.putInMessageList()
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
        getTasks()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getTasks), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func retrieveConversations() {
        
        let query1 = PFQuery(className: "Message")
        let query2 = PFQuery(className: "Message")
        query1.whereKey("sender", equalTo: PFUser.current()!.objectId!)
        query2.whereKey("recipient", equalTo: PFUser.current()!.objectId!)
        
        query1.findObjectsInBackground {(m, error) in
            if let m = m {
                for message in m.reversed(){
                    if !self.userList.contains(message["recipient"] as! String){
                        self.userList.append(message["recipient"] as! String)
                        
                    }
                }
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
        
        query2.findObjectsInBackground {(m, error) in
            if let m = m {
                for message in m.reversed(){
                    if !self.userList.contains(message["sender"] as! String){
                        self.userList.append(message["sender"] as! String)
                    }
                }
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
                
            }
        }
    }
    
    func putInMessageList() {
        print(userList)
        for userId in userList {
            let q = PFUser.query()
               q?.whereKey("objectId", equalTo: userId)
               q?.findObjectsInBackground(block: { (s, e) in
                   if let s = s {
                       print("Successfully retrieved \(s.count) users.")
                       self.messageList.append(s[0])
                   }
                self.tableView.reloadData()
            })
        }
  
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.message, for: indexPath) as! MessageCell
        if messageList.count > 0 {
            let user = messageList[indexPath.row]
            cell.otherUserLabel.text = user["name"] as? String
        }

        return cell
        
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
               //let listingUserId = user?.objectId as? String
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let details = messageList[indexPath.row]
        let chatViewController = segue.destination as! ChatViewController
        chatViewController.otherUser = details as! PFUser
        self.tableView.deselectRow(at: indexPath, animated: true)

        
    }
    
    @objc func getTasks() {
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
        refresh()
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    func refresh() {
        run(after: 2) {
           self.refreshControl.endRefreshing()
        }
    }
    
        

        
    
    

}
