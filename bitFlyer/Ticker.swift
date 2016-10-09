//
//  Ticker.swift
//  bitFlyer
//
//  Created by Hiroaki Miura on 2016/10/08.
//  Copyright © 2016 oisu. All rights reserved.
//

import ObjectMapper

class Ticker: Mappable {

    var timestamp: String?
    var bestAsk: Double?
    var bestBid: Double?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        timestamp <- map["timestamp"]
        bestAsk   <- map["best_ask"]
        bestBid   <- map["best_bid"]
    }
}
