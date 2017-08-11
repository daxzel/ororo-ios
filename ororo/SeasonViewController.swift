//
//  SeasonViewController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 23/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation


class SeasonViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var show: Show? = nil
    var episodes: [Episode] = []
    var actionsToEpisode: [UIButton: Episode] = [:]
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
        actionsToEpisode[playButton] = episode
        
        let downloadButton = popupViewController!.view.viewWithTag(2) as! UIButton
        downloadButton.addTarget(self, action: #selector(SeasonViewController.downloadAction(_:)), for: .touchUpInside)
        actionsToEpisode[downloadButton] = episode
        
        if ShowDAO.getDownloadedEpisode(episode.id) != nil {
            downloadButton.isEnabled = false
        }
        
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
            if let episode = actionsToEpisode[sender] {
                
                if let downloadedEpisode = ShowDAO.getDownloadedEpisode(episode.id),
                    downloadedEpisode.isDownloadFinished {
                    runEpisode(episode: downloadedEpisode)
                } else {
                    ShowAPI.getEpisodeDetailed(id: episode.id, viewController: self, completionHandler: { (episodeDetailed) in
                        self.runEpisode(episode: episodeDetailed)
                    })
     
                }
            }
        }
    }
    
    func runEpisode(episode: EpisodeDetailed) {
        let subtitlesUrl = episode.getPreparedSubtitlesDownloadUrl(lang: "en")
        let downloadUrl = episode.getPreparedDownloadUrl()
        
        let playerController = OroroPlayerViewController(url: downloadUrl, subtitles: subtitlesUrl)
        self.present(playerController, animated: true)
    }
    
    @IBAction func downloadAction(_ sender: UIButton) {
        if (popupViewController != nil) {
            popupViewController?.dismiss(animated: true, completion: nil)
            if let episode = actionsToEpisode[sender] {
                ShowAPI.getEpisodeDetailed(id: episode.id, viewController: self, completionHandler: { (episodeDetailed) in
                    ContentDownloader.load(show: self.show!, episode: episodeDetailed)
                    self.tableView.reloadData()
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
        
        let progressLabel = cell.contentView.viewWithTag(4) as! UILabel
        
        if  let downloadedEpisode = ShowDAO.getDownloadedEpisode(episode.id) {
            if (!downloadedEpisode.isDownloadFinished) {
                let listener = ContentDownloadListener(downloadProgressLabel: progressLabel)
                ContentDownloader.subscribeToDownloadProgress(requester: episode, listener: listener)
                progressLabel.isHidden = false
            } else {
                progressLabel.isHidden = false
                progressLabel.backgroundColor = ColorHelper.UIColorFromRGB(color: "31A480", alpha: 0.3)
                progressLabel.text = nil
            }
        } else {
            progressLabel.isHidden = true
        }
        
        return cell
    }
}
