//
//  ChatViewController.swift
//  Kader
//
//  Created by user165579 on 6/17/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatView_TV_messagePlaceholder: UITextField!
    @IBOutlet weak var chatView_TBL_chat: UITableView!

   // Firebase chat service utility
   var fbChatService: FirebaseFirestoreChatService!
   
    // Message list hold the messages which displyed
    var messageList = [Message]()
 
    // Hold the current group the chat is on
    var group: Group!
    
    // Hold the current user
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatView_TBL_chat.dataSource = self
        chatView_TBL_chat.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageReusableIdentifier")
        fbChatService = FirebaseFirestoreChatService(vc: self, callback: self)
        fbChatService.readMessages(group: group)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

    }
    
    // MARK: - Table view data source
    
    @IBAction func chatView_BTN_sendMessage(_ sender: UIButton) {
        if let message = chatView_TV_messagePlaceholder.text, let messageSender = Auth.auth().currentUser?.email {
            if !message.isEmpty {
                let newMessage = Message(sender: messageSender,userName: user.userName, body: message)
                fbChatService.writeNewMessage(group: self.group, message: newMessage)
            }
            DispatchQueue.main.async {
                self.chatView_TV_messagePlaceholder.text = ""
                
            }
        }
    }
}

// MARK: - CHAT DATA SOURCE
extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageReusableIdentifier", for: indexPath) as! MessageCell
        let message = messageList[indexPath.row]
        cell.chatView_LBL_bodyMessage.text = message.body
        cell.chatView_LBL_sentBy.text = message.sender
        if message.sender == Auth.auth().currentUser?.email {
            cell.chatView_IMG_imageLeft.isHidden = false
            cell.chatView_VIEW_imageRight.isHidden = true
        }else {
            cell.chatView_IMG_imageLeft.isHidden = true
            cell.chatView_VIEW_imageRight.isHidden = false
            cell.chatView_LBL_userName.text = getNameBySeperator(name: message.userName)
        }
        return cell
    }
    
    
    func getNameBySeperator(name: String) -> String {
        let split = name.components(separatedBy: " ")
        let firstCharFirstName = split[0].first
        let firstCharLastName = split[1].first
        return String("\(firstCharFirstName!)\(firstCharLastName!)")
    }
}

// MARK: - CHAT CALLBACK

extension ChatViewController: ChatCallback {
    func onFinishDownloadMessages(messageList: [Message]) {
        self.messageList = messageList
        DispatchQueue.main.async {
            self.chatView_TBL_chat.reloadData()
            if !messageList.isEmpty{
            let indexPath = IndexPath(row: self.messageList.count - 1, section: 0)
            self.chatView_TBL_chat.scrollToRow(at: indexPath, at: .top , animated: true)
            }
        }
    }
    
}
