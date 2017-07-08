//
//  MovieViewController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 08/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var countriesLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!

    var movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameLabel.text = nameLabel.text?.appending(movie.name)
        nameLabel.text = nameLabel.text?.appending(movie.year)
        ImagesHolder.updateImage(stringUrl: movie.poster_thumb, imageView: movieImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
