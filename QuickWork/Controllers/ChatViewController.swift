//
//  ChatViewController.swift
//  QuickWork
//
//  Created by Joshua Chan on 5/27/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

//import UIKit
import Parse
import MessageKit
import MessageInputBar
class ChatViewController: MessagesViewController, MessageInputBarDelegate, MessagesLayoutDelegate, MessagesDisplayDelegate {

    
    //@IBOutlet weak var messagesCollectionView: MessagesCollectionView!
    var showsMessageBar = true
    //var messagesCollectionView = MessagesCollectionView()
    let messageBar = MessageInputBar()
    var otherUser = PFObject(className: "User")
    var messages: [Message] = []
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.title = otherUser["name"] as? String
        self.configureMessageInputBar()
        retrieveChatMessages()
        Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.retrieveChatMessages), userInfo: nil, repeats: true)
        /*
        let sender = Sender(PFUser.current()!.objectId!, PFUser.current()!.username!)
        let currentDate = Date()
        let testMessage = Message(sender, PFUser.current()!.objectId!, currentDate, .text("I love pizza, what is your favorite kind?"))
        insertNewMessage(testMessage)*/
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
        
        }
        
     
    
    
  
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messages.sort { $0.sentDate < $1.sentDate}

        messagesCollectionView.reloadData()
      
      
    }
    
    @objc func retrieveChatMessages() {
        // RETRIEVE MESSAGES
        self.messages.removeAll()
        let query1 = PFQuery(className: "Message")
        let query2 = PFQuery(className: "Message")
        query1.whereKey("sender", equalTo: PFUser.current()!.objectId!)
        query1.whereKey("recipient", equalTo: otherUser.objectId!)
        
        query2.whereKey("sender", equalTo: otherUser.objectId!)
        query2.whereKey("recipient", equalTo: PFUser.current()!.objectId!)
        
        query1.findObjectsInBackground {(m, error) in
            if let m = m {
                //var temp = [MessageType]()
                for message in m{
                    
                    let sender = Sender(message["sender"]! as! String, message["sender"]! as! String)
                    let cell = Message(sender, message.objectId!, message.createdAt!, .text(message["message"] as! String))
                   
                    self.insertNewMessage(cell)
                    
                }
                
            } else {
                print(error!.localizedDescription)
            }
        }
        
        query2.findObjectsInBackground {(m, error) in
            if let m = m {
                for message in m{
                    let sender = Sender(message["sender"]! as! String, message["sender"] as! String)
                    let cell = Message(sender, message.objectId!, message.createdAt!, .text(message["message"] as! String))
                    self.insertNewMessage(cell)
                }
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
        let chatMessage = PFObject(className: "Message")
        if messageBar.inputTextView.text != nil {
            chatMessage["sender"] = PFUser.current()!.objectId!
            chatMessage["name"] = PFUser.current()!["name"]
            chatMessage["recipient"] = otherUser.objectId!
            chatMessage["message"] = messageBar.inputTextView.text!
            chatMessage.saveInBackground { (success, error) in
                if error != nil {
                    print("Message could not be sent!")
                } else {
                    print("Message sent!")
                    let sender = Sender(chatMessage["sender"]! as! String, chatMessage["name"]! as! String)
                    let cell = Message(sender, chatMessage.objectId!, chatMessage.createdAt!, .text(chatMessage["message"] as! String))
                    self.messages.append(cell)
                    self.messagesCollectionView.reloadData()
                    
                    //clear and dismiss the input bar
                    self.messageBar.inputTextView.text = nil
                    self.becomeFirstResponder()
                }
            }
            
        }
        
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
    func avatarSize(for message: MessageType, at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView) -> CGSize {

      // 1
      return .zero
    }

    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView) -> CGSize {

      // 2
      return CGSize(width: 0, height: 8)
    }

    func heightForLocation(message: MessageType, at indexPath: IndexPath,
      with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {

      // 3
      return 0
    }



    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView) -> UIColor {
      
      // 1
      return isFromCurrentSender(message: message) ? .blue : .gray
    }

    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView) -> Bool {

      // 2
      return false
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

      let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft

      // 3
      return .bubbleTail(corner, .curved)
    }
    
}


extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(PFUser.current()!.objectId!, PFUser.current()!["name"] as! String)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    // 3
    func messageForItem(at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> MessageType {

        return messages[indexPath.section]
    }

    // 4
    func cellTopLabelAttributedText(for message: MessageType,
    at indexPath: IndexPath) -> NSAttributedString? {

        let name = message.sender.displayName
        return NSAttributedString(
          string: name,
          attributes: [
            .font: UIFont.preferredFont(forTextStyle: .caption1),
           
          ]
        )
    }
}


public struct Sender: SenderType {
    public var senderId: String
    public var displayName: String
    init(_ id: String, _ name:String){
        senderId = id
        displayName = name
    }
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    init(_ s: SenderType, _ mid:String, _ sd: Date, _ k: MessageKind){
        sender = s
        messageId = mid
        sentDate =  sd
        kind = k
        
    }
}






