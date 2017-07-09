//
//  ColorHelper.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 09/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import UIKit

class ColorHelper {
    static func UIColorFromRGB(color: String, alpha: Double) -> UIColor {
        var rgbValue : UInt32 = 0
        let scanner = Scanner(string: color)
        scanner.scanLocation = 1
        
        if scanner.scanHexInt32(&rgbValue) {
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0xFF) / 255.0
            
            return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
        }
        
        return UIColor.black
    }
}
