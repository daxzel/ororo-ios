//
//  SubtitlesViewController.swift
//  ororo
//
//  Created by Sergey Sivak on 12/28/18.
//  Copyright © 2018 Andrey Tsarevskiy. All rights reserved.
//

import UIKit

class SubtitlesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var languages: [(code: String, label: String)] = []
    
    override func loadView() {
        super.loadView()
        tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "subtitles", ofType: "plist")!) as? [String: Any] {
            languages = (dict["supported"] as? [String: String] ?? [:]).map({ (code: $0, label: $1) })
        } else {
            languages = []
        }
    }
}

extension SubtitlesViewController: UITableViewDataSource {
    
    var cellIdentifier: String { return "languageCell" }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = languages[indexPath.row].label
        cell.accessoryType = languages[indexPath.row].code == Settings.prefferedSubtitleCode ? .checkmark : .none
        
        return cell
    }
}
