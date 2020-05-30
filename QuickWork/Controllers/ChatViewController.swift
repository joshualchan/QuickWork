//
//  ChatViewController.swift
//  QuickWork
//
//  Created by Joshua Chan on 5/27/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import Parse
import MessageKit
import MessageInputBar
class ChatViewController: MessagesViewController, MessageInputBarDelegate {
    
    @IBOutlet var messagesCollectionView: MessagesCollectionView!
    var showsMessageBar = true
    let chatMessage = PFObject(className: "Message")
    let messageBar = MessageInputBar()
    var otherUserId: String = ""
    var messages: [PFObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageInputBar()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.retrieveChatMessages), userInfo: nil, repeats: true)
    }
    
    @objc func retrieveChatMessages() {
        // RETRIEVE MESSAGES
        let query1 = PFQuery(className: "Messages")
        let query2 = PFQuery(className: "Messages")
        
        query1.whereKey("sender", equalTo: PFUser.current()!)
        query1.whereKey("recipient", equalTo: otherUserId)
        
        query2.whereKey("sender", equalTo: otherUserId)
        query2.whereKey("recipient", equalTo: PFUser.current()!)
        
        query1.findObjectsInBackground {(messages, error) in
            if let messages = messages {
                self.messages.append(contentsOf: messages)
                self.messagesCollectionView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
        query2.findObjectsInBackground {(messages, error) in
            if let messages = messages {
                self.messages.append(contentsOf: messages)
                self.messagesCollectionView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        messageBar.inputTextView.text = nil
        showsMessageBar = false
        becomeFirstResponder()
    }
    override var inputAccessoryView: UIView? {
        return messageBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsMessageBar
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //create the message
        if messageBar.inputTextView.text != nil {
            chatMessage["sender"] = PFUser.current()
            chatMessage["recipient"] = otherUserId
            chatMessage["message"] = messageBar.inputTextView.text as! String
            chatMessage.saveInBackground { (success, error) in
                if error != nil {
                    print("Message could not be sent!")
                } else {
                    print("Message sent!")
                }
            }
        }
       //save the message
        
        messagesCollectionView.reloadData()
        
        //clear and dismiss the input bar
        messageBar.inputTextView.text = nil
        //showsMessageBar = false
        becomeFirstResponder()
        messageBar.inputTextView.resignFirstResponder()
        
    }
    
    
    func configureMessageInputBar() {
        messageBar.delegate = self
    
        messageBar.inputTextView.tintColor = .blue
        messageBar.sendButton.setTitleColor(.blue, for: .normal)
        messageBar.sendButton.setTitleColor(
            UIColor.blue.withAlphaComponent(0.3),
            for: .highlighted
        )
    }

}
