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
    var messageList = [Message]()
    var userList = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveConversations()
        // Do any additional setup after loading the view.
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
                        let sender = Sender(message["sender"]! as! String, message["sender"]! as! String)
                        let cell = Message(sender, message.objectId!, message.createdAt!, .text(message["message"] as! String))
                        self.userList.append(message["recipient"] as! String)
                        self.messageList.append(cell)
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
                    let sender = Sender(PFUser.current()!.objectId!, message["sender"] as! String)
                    let cell = Message(sender, message.objectId!, message.createdAt!, .text(message["message"] as! String))
                    if !self.userList.contains(message["sender"] as! String){
                        let sender = Sender(message["sender"]! as! String, message["sender"]! as! String)
                        let cell = Message(sender, message.objectId!, message.createdAt!, .text(message["message"] as! String))
                        self.userList.append(message["recipient"] as! String)
                        self.messageList.append(cell)
                        self.tableView.reloadData()
                    } else{
                        let range = 0...self.messageList.count-1
                        for i in range {
                            if self.messageList[i].sender.senderId == PFUser.current()!.objectId! && self.messageList[i].sentDate < message.createdAt! {
                                let sender = Sender(message["sender"]! as! String, message["sender"]! as! String)
                                let cell = Message(sender, message.objectId!, message.createdAt!, .text(message["message"] as! String))
                                self.messageList[i] = cell
                            }
                        }
                        
                    
                    }
                }
                self.messageList.sort { $0.sentDate > $1.sentDate}
                print(self.messageList)
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.message, for: indexPath) as! MessageCell
        let msg = messageList[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        cell.otherUserLabel.text = msg.sender.displayName
        cell.dateLabel.text = formatter.string(from: msg.sentDate)
        cell.messageLabel.text = msg.messageId
        
        return cell
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
               //let listingUserId = user?.objectId as? String
        
        if sender is UITableViewCell{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let details = messageList[indexPath.row]
            let p = PFQuery(className: "User")
            p.whereKey("objectId", equalTo: details.sender.senderId)
            p.findObjectsInBackground { (u, error) in
                if let u = u {
                    let chatViewController = segue.destination as! ChatViewController
                    chatViewController.otherUser = u[0]
                    
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
            }

        }
    }
    

}
