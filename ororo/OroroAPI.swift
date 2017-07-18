//
//  OroroAPI.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 05/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol OroroAuthentificationProtocol {
    func authSuccessful()
    func authUnsuccessful()
    func connectionError()
}

class OroroAPI {
    
    static let testURL = "https://ororo.tv/api/v2/movies"
    
    static var auth: (key: String, value: String)? = nil
    
    static func setUpAuth(user: User) {
        auth = (key: "Authorization", value: user.encryptedUserPassword)
    }
    
    static func setUpAuth(email: String, password: String) -> String {
        auth = Request.authorizationHeader(user: email, password: password)
        return auth.unsafelyUnwrapped.value
    }
    
    static func testAuthentication(email: String, password: String, hadler: OroroAuthentificationProtocol) {
        auth = Request.authorizationHeader(user: email, password: password)
        let header = getHeader()
        Alamofire.request(testURL, headers: header)
            .response(completionHandler: { (response) in
                if let statusCode = response.response?.statusCode {
                    switch(statusCode) {
                        case (401):
                            hadler.authUnsuccessful()
                        case _ where (statusCode >= 200 && statusCode < 300):
                            hadler.authSuccessful()
                        default:
                            hadler.connectionError()
                    }
                } else {
                    if response.error != nil {
                        hadler.connectionError()
                    }
                }
            })
    }
    
    static internal func getHeader() -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        if let key = auth?.key,
            let value = auth?.value {
            headers[key] = value
        }
        return headers
    }
    
}
