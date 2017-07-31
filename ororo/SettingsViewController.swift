//
//  SettingsViewController.swift
//  ororo
//
//  Created by Tcarevskii, Andrei on 7/31/17.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation


class SettingsViewController: UIViewController {
    
    @IBOutlet weak var unloginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unloginButton?.layer.cornerRadius = 5.0
    }

    @IBAction func unloginAction(_ sender: Any) {
        CacheHelper.clear()
        ContentDownloader.cleanDownloads()
        DbHelper.deleteDb()
        OroroAPI.cleanAuth()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
    
}
