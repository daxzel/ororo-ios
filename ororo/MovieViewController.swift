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
    
    @IBOutlet weak var playButton: UIButton!
    
    var movie: Movie? = nil
    var dropDown: DropDown? = nil
    
    @IBOutlet weak var downloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.title = movie?.name
        
        nameLabel.text = nameLabel.text?.appending(movie!.name)
        yearLabel.text = yearLabel.text?.appending(movie!.year)
        genreLabel.text = genreLabel.text?.appending(movie!.genres)
        descriptionLabel.text = descriptionLabel.text?.appending(movie!.desc)
        countriesLabel.text = countriesLabel.text?.appending(movie!.countries)
        
        initImage()
        
        initLanguageButton()
        initDownloadButton()
        
        playButton.layer.cornerRadius = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadDetails()
    }
    
    func initImage() {
        movieImage.layer.cornerRadius = 2.0
        movieImage.clipsToBounds = true
        ImagesHolder.updateImage(stringUrl: movie!.posterThumb, imageView: movieImage)
    }
    
    func initLanguageButton() {
        languageButton.setTitle(Settings.prefferedSubtitleCode.uppercased(), for: .normal)
        languageButton.layer.cornerRadius = 5.0
        dropDown = DropDown()
        dropDown?.anchorView = languageView
        dropDown?.cellHeight = 40
        dropDown?.backgroundColor = ColorHelper.UIColorFromRGB(color: "#31A480", alpha: 1.0)
        dropDown?.selectionBackgroundColor = ColorHelper.UIColorFromRGB(color: "#3BC79C", alpha: 1.0)
        dropDown?.textColor = UIColor.white
        dropDown?.direction = .top
        dropDown?.shadowColor = ColorHelper.UIColorFromRGB(color: "#000000", alpha: 0.0)
        dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.languageButton.titleLabel?.text = item
        }
    }
    
    func updateLanguages(languages: [String]) {
        dropDown?.dataSource = languages
        if let index = languages.index(of: Settings.prefferedSubtitleCode.uppercased()) {
            dropDown?.selectRow(at: index)
            languageButton.setTitle(languages[index], for: .normal)
        } else if let index = languages.index(of: Settings.defaultSubtitleCode.uppercased()) {
            dropDown?.selectRow(at: index)
            languageButton.setTitle(languages[index], for: .normal)
        } else {
            let index = 0
            dropDown?.selectRow(at: index)
            languageButton.setTitle(languages[index], for: .normal)
        }
    }
    
    func initDownloadButton() {
        if let id = movie?.id {
            if ((MovieDAO.getDownloadedMovie(id)) != nil) {
                downloadButton.isEnabled = false
            }
        }
        downloadButton.layer.cornerRadius = 5.0
    }
    
    func downloadDetails() {
        if let id = movie?.id {
            MovieAPI.forOneMovie(id: id) { (movieDetailed) in
                self.movie = movieDetailed
                self.updateLanguages(languages: movieDetailed.subtitles.map({$0.lang.uppercased()}))
            }
        }
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        if let detailed = movie as? MovieDetailed {
            downloadButton.isEnabled = false
            ContentDownloader.load(movie: detailed)
        }
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        if let detailed = movie as? MovieDetailed {
            let lang = languageButton.titleLabel!.text?.lowercased()
            
            let subtitlesUrl = detailed.getPreparedSubtitlesDownloadUrl(lang: lang!)
            let downloadUrl = detailed.getPreparedDownloadUrl()
            
            let playerController = OroroPlayerViewController(url: downloadUrl, subtitles: subtitlesUrl)
            present(playerController, animated: true)
        }
        
    }

    @IBAction func selectLanguage(_ sender: Any) {
        dropDown?.show()
    }
}
