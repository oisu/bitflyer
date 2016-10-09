//
//  CandleStick.swift
//  bitFlyer
//
//  Created by Hiroaki Miura on 2016/10/07.
//  Copyright © 2016 oisu. All rights reserved.
//

import Charts

class CandleStick: CandleChartDataEntry {

    convenience init(xValue: Double, high: Double, low: Double, open: Double, close: Double) {
        self.init(x: xValue, shadowH: high, shadowL: low, open: open, close: close)
    }
}
