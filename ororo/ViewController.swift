//
//  ViewController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 01/03/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import UIKit


enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

