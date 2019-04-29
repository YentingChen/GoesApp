//
//  ProfilePersonalTableViewCell.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class ProfilePersonalTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var editImageView: UIImageView!
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
