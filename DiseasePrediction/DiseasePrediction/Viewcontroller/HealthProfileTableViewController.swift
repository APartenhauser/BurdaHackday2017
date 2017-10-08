//
//  HealthProfileTableViewController.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

enum HealthProfileSection {
    case profile, additionalInformation, apiData
    
    static func allSections() -> Array<HealthProfileSection> {
        return [.profile, .additionalInformation, .apiData]
    }
    func title() -> String {
        switch self {
        case .profile:
            return "WELCOME"
        case .apiData:
            return "MY NOKIA DATA"
        default:
            return ""
        }
    }
}

class HealthProfileTableViewController: UITableViewController, SingleSwitchTableViewCellDelegate {

    var healthProfile: HealthProfile {
        return ProfileManager.shared.healthProfile
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        tableView.addTableViewCell(for: ProfileTableViewCell.self)
        tableView.addTableViewCell(for: SingleMeasureTableViewCell.self)
        tableView.addTableViewCell(for: SingleSwitchTableViewCell.self)
        // http://0ad94da2.ngrok.io/burdahackday5/rest/data/measure/1
        
        
//        healthProfile.measures = Measures.allMeasures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Settings.shared.load(forKey: SettingKeys.loggedInKey, defaultValue: false) {
            NetworkManager.shared.requestAll([:], serializer: NokiaApiDeserializer<Measure>.self, route: "/rest/data/measure/2", baseURL: "http://0ad94da2.ngrok.io/burdahackday5") { (deserializer, error) in
                guard let newMeasures = deserializer?.objects else {
                    self.healthProfile.measures.removeAll()
                    self.healthProfile.measures += Measures.allMeasures()
                    self.tableView.reloadData()
                    return
                }
                self.healthProfile.measures.removeAll()
                self.healthProfile.measures += newMeasures
                self.tableView.reloadData()
            }
            return
        }
        
        if !Settings.shared.load(forKey: SettingKeys.firstStartKey, defaultValue: false) {
            showLogin()
            return
        }
    }

    func showLogin() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return
        }
        present(vc, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return HealthProfileSection.allSections().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let healthSection = HealthProfileSection.allSections()[section]
        switch healthSection {
        case .profile:
            return 1
        case .apiData:
            return healthProfile.measures.count
        case .additionalInformation:
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let healthSection = HealthProfileSection.allSections()[indexPath.section]
        if healthSection == .profile {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.Identifer, for: indexPath) as! ProfileTableViewCell
            
            cell.update(with: healthProfile)
            
            return cell
        }
        if healthSection == .additionalInformation {
            let cell = tableView.dequeueReusableCell(withIdentifier: SingleSwitchTableViewCell.Identifer, for: indexPath) as! SingleSwitchTableViewCell
            
            if indexPath.row == 0 {
                cell.descriptionTextLabel.text = "Smoker"
                cell.singleSwitch.isOn = healthProfile.demographicAdditions.smoker
            } else if indexPath.row == 1 {
                cell.descriptionTextLabel.text = "Active Sportsman"
                cell.singleSwitch.isOn = healthProfile.demographicAdditions.activeSportsman
            }
            cell.delegate = self
            return cell
        }
        if healthSection == .apiData {
            let cell = tableView.dequeueReusableCell(withIdentifier: SingleMeasureTableViewCell.Identifer, for: indexPath) as! SingleMeasureTableViewCell
            let measure = healthProfile.measures[indexPath.row]
            cell.update(with: measure)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let healthSection = HealthProfileSection.allSections()[section]
        if healthSection == .apiData || healthSection == .profile {
            let header = TableHeaderView(frame: CGRect(x: 10, y: 0, width: view.bounds.width-20, height: 50))
            
            header.update(with: healthSection.title())
            
            return header
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let healthSection = HealthProfileSection.allSections()[section]
        if healthSection == .apiData || healthSection == .profile {
            return 50
        }
        return 0
    }
    
    func didSelect(_ cell: SingleSwitchTableViewCell, state: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        if indexPath.row == 0 {
            healthProfile.demographicAdditions.smoker = state
        } else if indexPath.row == 1 {
            healthProfile.demographicAdditions.mySportsType = state ? .normal : .unSporty
        }
    }
}
