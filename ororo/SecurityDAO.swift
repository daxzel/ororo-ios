//
//  SecurityDAO.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 17/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import RealmSwift

class SecurityDAO {
    
    static func getUser() -> User? {
        let realm = try! Realm()
        return realm.objects(User.self).first
    }
    
    static func setUser(user: User) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(user)
        }
    }
    
}
