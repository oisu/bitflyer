//
//  Quote.swift
//  bitFlyer
//
//  Created by Hiroaki Miura on 2016/10/09.
//  Copyright © 2016 oisu. All rights reserved.
//

import ObjectMapper

class Quote: Mappable {

    var price: Double?
    var size: Double?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        price  <- map["price"]
        size   <- map["size"]
    }
}
