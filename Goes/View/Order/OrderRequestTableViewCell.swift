//
//  OrderRequestTableViewCell.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class OrderRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var requestName: UILabel!
    
    @IBOutlet weak var moreImage: UIImageView!
    @IBOutlet weak var requestTime: UILabel!
    @IBOutlet weak var requestLocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
