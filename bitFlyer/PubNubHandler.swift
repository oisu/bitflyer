//
//  PubNubHandler.swift
//  bitFlyer
//
//  Created by Hiroaki Miura on 2016/10/07.
//  Copyright © 2016 oisu. All rights reserved.
//

import PubNub

class PubNubHandler {

    fileprivate var client: PubNub

    init() {
        let config = PNConfiguration(
            publishKey: Const.PubNub.publishKey,
            subscribeKey: Const.PubNub.subscribeKey
        )
        let channel = Const.PubNub.channelName

        Logger.print("Connecting to: " + Const.PubNub.channelName)

        client = PubNub.clientWithConfiguration(config)
        subscribeToChannel(channel: channel)
    }

    private func subscribeToChannel(channel: String) {
        client.subscribeToChannels([channel], withPresence: false)
    }
    
    func addHandler(listener: PNObjectEventListener!) {
        client.addListener(listener)
    }
}
