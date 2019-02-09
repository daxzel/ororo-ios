//
//  MessageHelper.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 30/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation


class MessageHelper {

    static func connectionError(viewController: UIViewController, data: String = "Connection error") {
        let alert = UIAlertController(title: "Error", message: data,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
