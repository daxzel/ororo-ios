//
//  ShowsAPI.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 18/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ShowAPI {
    
    static let showsURL = "https://ororo.tv/api/v2/shows"

    static func getAllShows(completionHandler: @escaping (_ result: Result<Any>, [Show]) -> Void) {
        
        Alamofire.request(showsURL, headers: OroroAPI.getHeader())
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        let showsJSON = JSON(data: data)["shows"]
                        let shows = showsJSON.arrayValue.map({ (json) -> Show in
                            let show = Show()
                            Parser.parseContent(json: json, content: show)
                            return show
                        })
                        completionHandler(response.result, shows)
                    }
                case .failure(let error):
                    completionHandler(response.result, [])
                    print(error)
                }
                
        }
    }
    
}


