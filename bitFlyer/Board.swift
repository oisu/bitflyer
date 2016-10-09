//
//  Board.swift
//  bitFlyer
//
//  Created by Hiroaki Miura on 2016/10/09.
//  Copyright © 2016 oisu. All rights reserved.
//

import ObjectMapper

class Board: Mappable {

    var midPrice: Double?
    var bids: [Bid]?
    var asks: [Ask]?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        midPrice <- map["mid_price"]
        bids     <- map["bids"]
        asks     <- map["asks"]
    }
}

extension Board {
    func getQuotes(quoteType: QuoteType) -> [Quote]? {
        switch quoteType {
        case .ask:
            return asks
        case .bid:
            return bids
        }
    }
}
