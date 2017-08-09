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

class ShowViewController: UIViewController {
    
    @IBOutlet weak var pagesView: UIView!
    
    var episodes: [Episode] = []
    var show: Show? = nil
    var pagesContainer: DAPagesContainer? = nil
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityViewInit()
        self.title = show?.name
        initShow()
    }
    
    func activityViewInit() {
        activityView.center = self.view.center
        view!.addSubview(activityView)
        activityView.color = UIColor.black
        activityView.startAnimating()
    }
    
    func initShow() {
        if let id = show?.id {
            CacheHelper.getShow(id: id, viewController: self) { (showDetailed) in
                self.episodes = Array(showDetailed.episodes)
                self.activityView.stopAnimating()
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
        viewController.show = self.show
        viewController.episodes = episodes
        viewController.title = String(seasonNumber)
        return viewController
    }
    
}
