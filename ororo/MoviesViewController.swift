//
//  ViewController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 01/03/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import UIKit
import RealmSwift

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

class MoviesViewController: UICollectionViewController {

    static let realm =  try! Realm()
    let movies: Results<Movie> = MoviesViewController.realm.objects(Movie.self)
    var selectedMovie = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MoviesViewController.realm.objects(Movie.self).count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movies[indexPath.item]
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as UICollectionViewCell
        
        let movieNameLabel = movieCell.viewWithTag(1) as! UILabel
        movieNameLabel.text = movie.name
        
        let movieLogo = movieCell.viewWithTag(2) as! UIImageView
        ImagesHolder.updateImage(stringUrl: movie.poster_thumb, imageView: movieLogo)
        
        return movieCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            let destinationViewController = segue.destination as! MovieViewController
            let movie = movies[indexPath.row]
            destinationViewController.movie = movie
        }
    }

}

