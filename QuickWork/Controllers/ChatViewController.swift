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
    let sender = Sender(senderId: (PFUser.current()! as! PFObject)["username"] as! String, displayName: (PFUser.current()! as PFObject)["name"] as! String)
    let messages: [MessageType] = []
    var showsMessageBar = true
    let chatMessage = PFObject(className: "Message")
    let messageBar = MessageInputBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageInputBar()
        
        //messagesCollectionView.messagesDataSource = self
        //messagesCollectionView.messagesLayoutDelegate = self
        //messagesCollectionView.messagesDisplayDelegate = self
        // Do any additional setup after loading the view.
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

