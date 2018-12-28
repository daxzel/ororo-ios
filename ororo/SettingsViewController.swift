//
//  SettingsViewController.swift
//  ororo
//
//  Created by Tcarevskii, Andrei on 7/31/17.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation

class Settings {
    
    private static let kSettingsPrefferedSubtitleKey = "ORORO_PREFFERED_SUBTITLE_KEY"
    
    private static let kSettingsDefaultSubtitleKey = "en"
    
    static var defaultSubtitleCode: String {
        get { return kSettingsDefaultSubtitleKey }
    }
    
    static var prefferedSubtitleCode: String {
        get { return UserDefaults.standard.string(forKey: kSettingsPrefferedSubtitleKey) ?? kSettingsDefaultSubtitleKey }
        set { UserDefaults.standard.set(newValue, forKey: kSettingsPrefferedSubtitleKey) }
    }
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var unloginButton: UIButton!
    
    override func loadView() {
        super.loadView()
        unloginButton.layer.cornerRadius = 5.0
        tableView.dataSource = self
    }

    @IBAction func unloginAction(_ sender: Any) {
        CacheHelper.clear()
        BackgroundDownloader.cleanDownloads()
        DbHelper.deleteDb()
        OroroAPI.cleanAuth()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginViewController")
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func unwindToSettings(_ segue: UIStoryboardSegue) {
        if let source = segue.source as? SubtitlesViewController, let index = source.tableView.indexPathForSelectedRow?.row {
            Settings.prefferedSubtitleCode = source.languages[index].code
            tableView.reloadData()
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    var cellIdentifier: String { return "subtitlesCell" }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = "Preffered subtitles"
        cell.detailTextLabel?.text = Settings.prefferedSubtitleCode.uppercased()
        
        return cell
    }
}
