//
//  LoginViewController.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

enum LoginState: String {
    case success = "Login successfull"
    case failed = "Login Failed - Please try again"
    case waiting = "Logging in..."
}

class LoginViewController: UIViewController {
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = ""
    }
    
    @IBAction func login(_ sender: Any) {
        guard let user = loginField.text, let password = passwordField.text, user.count > 0 && password.count > 0 else {
            statusLabel.text = LoginState.failed.rawValue
            return
        }
        statusLabel.text = LoginState.waiting.rawValue
        // TODO - call Own Server to trigger oauth
        perform(#selector(LoginViewController.finish), with: nil, afterDelay: 1)
    }
    
    @objc func finish() {
        statusLabel.text = LoginState.success.rawValue
        Settings.shared.save(true, forKey: SettingKeys.firstStartKey)
        Settings.shared.save(true, forKey: SettingKeys.loggedInKey)
        perform(#selector(LoginViewController.dismiss(animated:completion:)), with: nil, afterDelay: 1)
    }
}
