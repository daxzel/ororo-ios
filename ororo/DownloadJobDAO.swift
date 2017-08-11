//
//  DownloadJobDAO.swift
//  ororo
//
//  Created by Tcarevskii, Andrei on 8/10/17.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import RealmSwift

class DownloadJobDAO {
    
    static func getDownloadJobs() -> Results<MainDownloadJob> {
        let realm = try! Realm()
        return realm.objects(MainDownloadJob.self)
    }
    
    static func saveDownloadJob(job: MainDownloadJob) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(job)
        }
    }
    
    static func getDownloadJob(_ id: String) -> MainDownloadJob? {
        let realm =  try! Realm()
        return realm
            .object(ofType: MainDownloadJob.self, forPrimaryKey: id)
    }

}


