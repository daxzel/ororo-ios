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

class MoviesViewController: UICollectionViewController {

    var moviesProvider: MoviesProviderProtocol? = nil
    var movies: [Movie]? = nil
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView.center = self.collectionView!.center
        collectionView!.addSubview(activityView)
        activityView.color = UIColor.black
    }
    
    func updateMovies() {
        activityView.startAnimating()
        
        moviesProvider?.getMovies { (movies) in
            self.movies = movies
            self.activityView.stopAnimating()
            self.collectionView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateMovies()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = movies?.count {
            return count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movies![indexPath.item]
        
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
        if  movie is DownloadedMovie {
            downloadProgressLabel.layer.cornerRadius = 2.0
            let listener = ContentDownloadListener(downloadProgressLabel: downloadProgressLabel)
            ContentDownloader.subscribeToDownloadProgress(id: movie.id, listener: listener)
        } else {
            downloadProgressLabel.isHidden = true
        }
        
        return movieCell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "MovieCellSegue" {
                if let downloadedMovie = movies?[0] as? DownloadedMovie {
                    return downloadedMovie.isDownloadFinished
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            let movie = movies![indexPath.row]
            let destinationViewController = segue.destination as! MovieViewController
            destinationViewController.movie = movie
        }
    }

}

