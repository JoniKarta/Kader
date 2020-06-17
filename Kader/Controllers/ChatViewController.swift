//
//  ChatViewController.swift
//  Kader
//
//  Created by user165579 on 6/17/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    var message1 = Message(body: "Hello Test1")
    var message2 = Message(body: "Hello Test2")
    var message3 = Message(body: "Hellow Test3")
    var messageList = [Message]()

    @IBOutlet weak var chatView_TBL_chat: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        messageList.append(message1)
        messageList.append(message2)
        messageList.append(message1)
        chatView_TBL_chat.delegate = self
        chatView_TBL_chat.dataSource = self
        chatView_TBL_chat.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageReusableIdentifier")
        
    }

    // MARK: - Table view data source

  
   
}
extension ChatViewController: UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return messageList.count
       }

       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "messageReusableIdentifier", for: indexPath) as! MessageCell
            cell.chatView_LBL_bodyMessage.text = messageList[indexPath.row].body
           
           return cell
       }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
