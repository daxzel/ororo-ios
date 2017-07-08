//
//  ImagesHolder.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 08/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import UIKit

class ImagesHolder {
    
    static let images: [String: Data?] = [:]
    
    static func updateImage(stringUrl: String, imageView: UIImageView) {
        if let image = images[stringUrl] {
            imageView.image = UIImage(data: image!)
        } else {
            let url = URL(string: stringUrl)
            downloadImage(url: url!, imageView: imageView)
        }
    }
    
    static func downloadImage(url: URL, imageView: UIImageView) {
        print("Image Download Started \(url.absoluteURL)")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Image Download Finished \(url.absoluteURL)")
            DispatchQueue.main.async() { () -> Void in
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    static func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

}
