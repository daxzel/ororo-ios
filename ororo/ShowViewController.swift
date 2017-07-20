//
//  ShowViewController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 19/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import UIKit

class ShowViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var showView: LDAlignmentImageView!
    var show: Show? = nil
    
    @IBOutlet weak var episodesTable: UITableView!
    
    var episodes: [Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = show?.name
        
        initImage()
        
        initEpisodesTable()
    }

    func initEpisodesTable() {
        episodesTable.rowHeight = 40
        episodesTable.dataSource = self
        if let id = show?.id {
            ShowAPI.getShow(id: id) { (showDetailed) in
                self.episodes = Array(showDetailed.episodes)
                self.episodesTable.reloadData()
            }
        }
    }
    
    func initImage() {
        showView.imageVerticalAlignment = LDImageVerticalAlignmentTop;
        showView.imageHorizontalAlignment = LDImageHorizontalAlignmentLeft;
        showView.imageContentMode = LDImageContentModeScaleAspectFill;
        ImagesHolder.updateImage(stringUrl: show!.posterThumb, imageView: showView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = episode.number + " " + episode.name
        return cell
    }
    
}
