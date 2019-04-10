//
//  LobbyFriendViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/5.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class LobbyFriendViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var tableView: UITableView!

    @IBAction func checkBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "選擇地點：\n台北市大安區100巷\n選擇時間：盡快抵達\n選擇朋友：Xian Wu", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.present(LobbyViewController(), animated: true, completion: nil)
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: "LobbyFriendCollectionViewCell",
                  bundle: nil),
            forCellWithReuseIdentifier: "lobbyFriendCollectionViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "LobbyFriendTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "lobbyFriendTableViewCell")

    }

    @IBAction func dismissBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
        present(LobbyViewController(), animated: true, completion: nil)
    }

}

extension LobbyFriendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2

    }

    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "lobbyFriendCollectionViewCell",
            for: indexPath) as? LobbyFriendCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
    -> CGSize {
        return CGSize(width: 80, height: 80)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int)
    -> CGFloat {
        return 5
    }

}

extension LobbyFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "lobbyFriendTableViewCell",
            for: indexPath) as? LobbyFriendTableViewCell else { return UITableViewCell() }
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
