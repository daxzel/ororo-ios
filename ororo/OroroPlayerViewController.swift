//
//  PlayerViewController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 09/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation
import UIKit

class OroroPlayerViewController: AVPlayerViewController {
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.player = AVPlayer(url: url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
}
