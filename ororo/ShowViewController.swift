//
//  ShowViewController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 19/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import UIKit
import DAPagesContainer

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
}

class SeasonViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var episodes: [Episode] = []
    var playActions: [UIButton: Episode] = [:]
    var popupViewController: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initEpisodesTable()
    }
    
    func initEpisodesTable() {
        self.tableView.rowHeight = 80
        self.tableView.register(UINib(nibName: "EpisodeView", bundle: nil), forCellReuseIdentifier: "EpisodeViewCell")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        
        popupViewController = UIViewController(nibName: "EpisodeActions", bundle: nil)
            
        popupViewController!.modalPresentationStyle = UIModalPresentationStyle.popover;
        popupViewController!.preferredContentSize = CGSize(width: CGFloat(100), height: CGFloat(50))
            
            
        let playButton = popupViewController!.view.viewWithTag(1) as! UIButton
        playButton.addTarget(self, action: #selector(SeasonViewController.playAction(_:)), for: .touchUpInside)
        playActions[playButton] = episode
            
        if let cellView = tableView.cellForRow(at: indexPath) {
            popupViewController!.popoverPresentationController?.delegate = self
            popupViewController!.popoverPresentationController?.sourceView = cellView // button
            popupViewController!.popoverPresentationController?.sourceRect = cellView.bounds
            self.present(popupViewController!, animated: true, completion: nil)
        }
     
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        if (popupViewController != nil) {
            popupViewController?.dismiss(animated: true, completion: nil)
            if let episode = playActions[sender] {
                ShowAPI.getEpisodeDetailed(id: episode.id, completionHandler: { (episodeDetailed) in
                    let subtitlesUrl = episodeDetailed.getPreparedSubtitlesDownloadUrl(lang: "en")
                    let downloadUrl = episodeDetailed.getPreparedDownloadUrl()
                    
                    let playerController = OroroPlayerViewController(url: downloadUrl, subtitles: subtitlesUrl)
                    self.present(playerController, animated: true)
                })
            }
     
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episode = episodes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeViewCell", for: indexPath)
        
        let numberLabel = cell.contentView.viewWithTag(1) as! UILabel
        numberLabel.text = String(episode.number)
        
        let nameLabel = cell.contentView.viewWithTag(2) as! UILabel
        nameLabel.text = episode.name
        
        let descriptionLabel = cell.contentView.viewWithTag(3) as! UILabel
        descriptionLabel.text = episode.plot
        
        return cell
    }
}

class ShowViewController: UIViewController {
    
    @IBOutlet weak var pagesView: UIView!
    
    var episodes: [Episode] = []
    var show: Show? = nil
    var pagesContainer: DAPagesContainer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = show?.name
        initShow()
    }
    
    func initShow() {
        if let id = show?.id {
            ShowAPI.getShow(id: id) { (showDetailed) in
                self.episodes = Array(showDetailed.episodes)
                self.initPagesView(episodes: self.episodes)
            }
        }
    }
    
    func initPagesView(episodes: [Episode]) {
        pagesContainer = DAPagesContainer()
        
        pagesContainer?.willMove(toParentViewController: self)
        pagesContainer?.view.frame = pagesView.bounds
        pagesContainer?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pagesView.addSubview(pagesContainer!.view)
        pagesContainer?.didMove(toParentViewController: self)
        pagesContainer?.topBarBackgroundColor = ColorHelper.UIColorFromRGB(color: "2E353D", alpha: 1.0)
        
        let seasons = self.episodes.group { (episode) in
            return episode.season
        }
        
        let viewControllers = seasons.keys.sorted().reversed().map { (seasonNumber) -> SeasonViewController in
            let episodes = seasons[seasonNumber]
            let sortedEpisodes = episodes!.sorted { return $0.number > $1.number }
            return self.createSeasonsViewController(episodes: sortedEpisodes, seasonNumber: seasonNumber)
        }
        pagesContainer?.viewControllers = Array(viewControllers)
    }
    
    func createSeasonsViewController(episodes: [Episode], seasonNumber: Int) -> SeasonViewController {
        let viewController = SeasonViewController()
        viewController.episodes = episodes
        viewController.title = String(seasonNumber)
        return viewController
    }
    
}
