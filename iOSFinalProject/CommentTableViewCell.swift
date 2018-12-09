//
//  CommentTableViewCell.swift
//  iOSFinalProject
//
//  Created by Michael Anastasio on 12/9/18.
//  Copyright © 2018 Michael Anastasio. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var userText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
