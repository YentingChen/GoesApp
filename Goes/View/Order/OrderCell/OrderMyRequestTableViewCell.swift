//
//  OrderMyRequestTableViewCell.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class OrderMyRequestTableViewCell: UITableViewCell {
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var moreInfoImageVIew: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
