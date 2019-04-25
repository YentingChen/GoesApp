//
//  OrderRequestHeaderTableViewCell.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/19.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class OrderRequestHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleView: UIView! {
        
        didSet {
            
            self.titleView.roundCorners(8)
            
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
