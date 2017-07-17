//
//  Security.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 17/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var encryptedUserPassword = ""
    dynamic var email = ""
}
