//
//  OrderRequestHeaderTableViewCell.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/19.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class OrderRequestHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerTxt: UILabel! {
        didSet {
            self.headerTxt.layer.cornerRadius = 8
            self.headerTxt.layer.masksToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
