//
//  Const.swift
//  bitFlyer
//
//  Created by Hiroaki Miura on 2016/10/05.
//  Copyright © 2016 oisu. All rights reserved.
//

struct Const {

    private init() {}

    struct PubNub {
        static let publishKey = "demo"
        static let subscribeKey = "sub-c-52a9ab50-291b-11e5-baaa-0619f8945a4f"
        static let channelName = "lightning_ticker_BTC_JPY"
        static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
    }
}
