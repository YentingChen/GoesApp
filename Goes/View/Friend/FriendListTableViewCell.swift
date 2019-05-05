//
//  FriendListTableViewCell.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!

    
    @IBOutlet weak var cellDeleteBtn: UIButton!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
