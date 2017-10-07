//
//  HomeViewController.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Health Tips"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Settings.shared.load(forKey: SettingKeys.loggedInKey, defaultValue: false) {
            return
        }
        
        if !Settings.shared.load(forKey: SettingKeys.firstStartKey, defaultValue: false) {
            showLogin()
        }
    }

    func showLogin() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return
        }
        present(vc, animated: true, completion: nil)
    }

}
