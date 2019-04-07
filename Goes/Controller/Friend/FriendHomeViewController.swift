//
//  FriendHomeViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/6.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class FriendHomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FriendMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "friendMenuCollectionViewCell")
    }
    

    
}

extension FriendHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellImage = ["search_image_40x","request_image_40x", "friend_image_40x", "sent_image_40x"]
        let cellTitle = ["搜尋好友", "好友邀請","好友列表", "送出"]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendMenuCollectionViewCell", for: indexPath) as! FriendMenuCollectionViewCell
        cell.menuImage.image = UIImage(named: cellImage[indexPath.row])
        cell.menuLabel.text = cellTitle[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    
    
}
