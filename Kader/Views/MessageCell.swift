//
//  MessageCell.swift
//  Kader
//
//  Created by user165579 on 6/17/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var chatView_LBL_bodyMessage: UILabel!
    @IBOutlet weak var chatView_VIEW_messageViewHolder: UIView!
    @IBOutlet weak var chatView_LBL_sentBy: UILabel!
    @IBOutlet weak var chatView_IMG_imageLeft: UIImageView!
    @IBOutlet weak var chatView_VIEW_imageRight: UIView!
    
    @IBOutlet weak var chatView_LBL_userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        chatView_VIEW_messageViewHolder.layer.cornerRadius = chatView_VIEW_messageViewHolder.frame.size.height / 5
        chatView_VIEW_imageRight.layer.cornerRadius = chatView_VIEW_imageRight.frame.size.height / 2
        chatView_VIEW_imageRight.clipsToBounds = true
        
    }
    
}
