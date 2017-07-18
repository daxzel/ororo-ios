//
//  ViewController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 01/03/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import UIKit
import RealmSwift

class ContentDownloadListener : ContentDownloadListenerProtocol {
    let downloadProgressLabel: UILabel
    
    init(downloadProgressLabel: UILabel) {
        self.downloadProgressLabel = downloadProgressLabel
    }
    
    func updateProgress(percent: Int64) {
        downloadProgressLabel.text = String(percent) + "%"
    }
    func finished() {
        downloadProgressLabel.isHidden = true
    }
}

class ContentViewController: UICollectionViewController, UISearchResultsUpdating {

    var contentProvider: ContentProviderProtocol? = nil
    var content: [Content]? = nil
    var filteredContent: [Content]? = nil
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView.center = self.collectionView!.center
        collectionView!.addSubview(activityView)
        activityView.color = UIColor.black
        
        initSearchBar()
    }
    
    func initSearchBar() {
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        self.navigationItem.titleView = searchController.searchBar
    }
    
    func updateMovies() {
        activityView.startAnimating()
        
        contentProvider?.getContent { (content) in
            self.content = content
            self.filteredContent = content
            self.activityView.stopAnimating()
            self.collectionView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initSearchBar()
        updateMovies()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = filteredContent?.count {
            return count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = filteredContent![indexPath.item]
        
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as UICollectionViewCell
        
        let movieNameLabel = movieCell.viewWithTag(1) as! UILabel
        movieNameLabel.text = movie.name
        
        let movieLogo = movieCell.viewWithTag(2) as! UIImageView
        //rounded logo
        movieLogo.layer.cornerRadius = 2.0
        
        movieLogo.clipsToBounds = true
        ImagesHolder.updateImage(stringUrl: movie.posterThumb, imageView: movieLogo)
        
        let downloadProgressLabel = movieCell.viewWithTag(3) as! UILabel
        // Download progress label
        if  let downloadedMovie = movie as? DownloadedMovie {
            if downloadedMovie.isDownloadFinished == true {
                downloadProgressLabel.isHidden = true;
            } else {
                downloadProgressLabel.isHidden = false;
                downloadProgressLabel.layer.cornerRadius = 2.0
                let listener = ContentDownloadListener(downloadProgressLabel: downloadProgressLabel)
                ContentDownloader.subscribeToDownloadProgress(id: movie.id, listener: listener)
            }
        } else {
            downloadProgressLabel.isHidden = true
        }
        
        return movieCell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "MovieCellSegue" {
                //TODO change movies?[0]
                if let downloadedMovie = content?[0] as? DownloadedMovie {
                    return downloadedMovie.isDownloadFinished
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            let movie = content![indexPath.row]
            let destinationViewController = segue.destination as! MovieViewController
            destinationViewController.movie = movie as! Movie
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText.isEmpty {
            filteredContent = content
        } else {
            let lowerCaseSearch = searchText.lowercased()
            filteredContent = content?.filter { movie in
                return movie.name.lowercased().contains(lowerCaseSearch)
            }
        }
        self.collectionView?.reloadData()
    }
    
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

}

