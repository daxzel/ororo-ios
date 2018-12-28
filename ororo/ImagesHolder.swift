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
    
    static var images: [String: Data?] = [:]
    
    static var lastUrls: [String: URL] = [:]
    
    static func updateImage(stringUrl: String, imageView: UIImageView) {
        if let image = images[stringUrl] {
            imageView.image = UIImage(data: image!)
        } else {
            if let url = URL(string: stringUrl) {
                imageView.image = nil
                downloadImage(url: url, imageView: imageView)
            }
        }
    }
    
    static func downloadImage(url: URL, imageView: UIImageView) {
        if let imageId = imageView.restorationIdentifier {
            lastUrls[imageId] = url
            getDataFromUrl(url: url) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                self.images[url.absoluteString] = data
                guard let lastUrl = lastUrls[imageId], lastUrl == url else { return }
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
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
