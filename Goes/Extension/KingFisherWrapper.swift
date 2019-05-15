//
//  KingFisherWrapper.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/10.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String, placeHolder: UIImage? = nil) {
        
        let url = URL(string: urlString)
        
        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
