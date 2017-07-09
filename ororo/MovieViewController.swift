//
//  MovieViewController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 08/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import DropDown

class MovieViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var countriesLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var languageButton: UIButton!
    
    var movie: Movie? = nil
    
    var dropDown: DropDown? = nil
    var movieDetailed: MovieDetailed? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        nameLabel.text = nameLabel.text?.appending(movie!.name)
        yearLabel.text = yearLabel.text?.appending(movie!.year)
        genreLabel.text = genreLabel.text?.appending(movie!.genres)
        descriptionLabel.text = descriptionLabel.text?.appending(movie!.desc)
        countriesLabel.text = countriesLabel.text?.appending(movie!.countries)
        
        movieImage.layer.cornerRadius = 2.0
        movieImage.clipsToBounds = true
        ImagesHolder.updateImage(stringUrl: movie!.posterThumb, imageView: movieImage)
        
        initLanguageField()
        
        languageButton.layer.cornerRadius = 2.0
        
        downloadDetails()
        
    }
    
    func initLanguageField() {
        dropDown = DropDown()
        dropDown?.anchorView = languageView
        dropDown?.cellHeight = 40
        dropDown?.backgroundColor = ColorHelper.UIColorFromRGB(color: "#444b54", alpha: 1.0)
        dropDown?.selectionBackgroundColor = ColorHelper.UIColorFromRGB(color: "#2E353D", alpha: 1.0)
        dropDown?.textColor = UIColor.white
        dropDown?.direction = .top
        dropDown?.shadowColor = ColorHelper.UIColorFromRGB(color: "#000000", alpha: 0.0)
        dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.languageButton.titleLabel?.text = item
        }
    }
    
    func updateLanguages(languages: [String]) {
        dropDown?.dataSource = languages
        dropDown?.selectRow(at: dropDown?.dataSource.index(of: "EN"))
    }
    
    func downloadDetails() {
        if let id = movie?.id {
            OroroAPI.forOneMovie(id: id) { (movieDetailed) in
                self.movieDetailed = movieDetailed
                
                self.updateLanguages(languages: movieDetailed.subtitles.map({$0.lang.uppercased()}))
            }
        }
    }
        
    @IBAction func playAction(_ sender: UIButton) {
        if let downloadUrl = movieDetailed?.downloadUrl,
            let subtitles = movieDetailed?.subtitles {
            
            if let subtitlesUrl = subtitles.filter({ (subtitle) -> Bool in
                return (subtitle.lang == self.languageButton.titleLabel!.text?.lowercased())
            }).first?.url {
                let downloadUrl = URL(string: downloadUrl)!
                let subtitlesUrl = URL(string: subtitlesUrl)!
                
                let playerController = OroroPlayerViewController(url: downloadUrl, subtitles: subtitlesUrl)
                self.present(playerController, animated: true)
    
            }
        }
    }

    @IBAction func selectLanguage(_ sender: Any) {
        dropDown?.show()
    }
    
}
