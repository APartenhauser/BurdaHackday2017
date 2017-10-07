//
//  HealthProfileTableViewController.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

enum HealthProfileSection {
    case profile, apiData
    
    static func allSections() -> Array<HealthProfileSection> {
        return [.profile, .apiData]
    }
}

class HealthProfileTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        tableView.addTableViewCell(for: ProfileTableViewCell.self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return HealthProfileSection.allSections().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let healthSection = HealthProfileSection.allSections()[section]
        switch healthSection {
        case .profile:
            return 1
        case .apiData:
            return 0 // TODO
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let healthSection = HealthProfileSection.allSections()[indexPath.section]
        if healthSection == .profile {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.Identifer, for: indexPath) as! ProfileTableViewCell
            
            return cell
        }
        
        return UITableViewCell()
    }
}
