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

public protocol MessageType {

    var sender: Sender { get }

    var messageId: String { get }

    var sentDate: Date { get }

    var kind: MessageKind { get }
}

public protocol SenderType {

    var senderId: String { get }
    
    var displayName: String { get }
}

public struct Sender: SenderType {
    public let senderId: String

    public let displayName: String
}

/*
// Some global variables for the sake of the example. Using globals is not recommended!
//let sender = Sender(senderId: PFUser.current()!["user"] as! String, displayName: "Steven")
//let messages: [MessageType] = []

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: PFUser.current()!["user"] as! String, displayName: "Steven")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }


}

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}

extension ChatViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()

        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }

    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = SampleData.shared.currentSender
            if let str = component as? String {
                let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            } else if let img = component as? UIImage {
                let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
}
*/
