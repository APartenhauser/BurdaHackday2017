//
//  HomeViewController.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    var data: Array<Article> = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Health Tips"
        tableView.addTableViewCell(for: ArticleTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Settings.shared.load(forKey: SettingKeys.firstStartKey, defaultValue: false) {
            NetworkManager.shared.requestAll(["number": "10", "topics": "mobile_welt"], serializer: ChipDeserializer<Article>.self) { (deserializer, error) in
                guard let articles = deserializer?.objects else {
                    return
                }
                self.data = articles
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.Identifer, for: indexPath) as! ArticleTableViewCell
        
        cell.update(with: data[indexPath.row])
        
        return cell
    }
}
