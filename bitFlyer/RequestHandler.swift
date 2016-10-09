//
//  RequestHandler.swift
//  bitFlyer
//
//  Created by Hiroaki Miura on 2016/10/09.
//  Copyright © 2016 oisu. All rights reserved.
//

import Foundation
import Alamofire

class RequestHandler {
    private init() {}

    static func request(urlString: String, onCompletion: @escaping (Result<Any>) -> Void) {

        Alamofire
            .request(urlString)
            .validate()
            .responseJSON { response in
                onCompletion(response.result)
        }
    }
}
