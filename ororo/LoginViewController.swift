//
//  LoginViewController.swift
//  ororo
//
//  Created by Tcarevskii, Andrei on 7/14/17.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func loginAction(_ sender: Any) {
        let targetStoryboardName = "Main"
        let targetStoryboard = UIStoryboard(name: targetStoryboardName, bundle: nil)
        if let targetViewController = targetStoryboard.instantiateInitialViewController() {
            self.present(targetViewController, animated: true)
        }
    }

}
