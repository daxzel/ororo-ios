//
//  ViewController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 01/03/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import UIKit
import RealmSwift

class MoviesViewController: UICollectionViewController {

    var movies: Results<Movie>? = nil
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView.center = self.collectionView!.center
        collectionView!.addSubview(activityView)
        activityView.color = UIColor.black
        activityView.startAnimating()
        
        DbHelper.updateMovies { (Void) in
            self.movies = DbHelper.readMoviesFromDB()
            self.activityView.stopAnimating()
            self.collectionView?.reloadData()
        }
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
        
        return movieCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            let destinationViewController = segue.destination as! MovieViewController
            let movie = movies![indexPath.row]
            destinationViewController.movie = movie
        }
    }

}

