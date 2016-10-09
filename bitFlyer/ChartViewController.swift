//
//  ChartViewController.swift
//  bitFlyer
//
//  Created by Hiroaki Miura on 2016/10/05.
//  Copyright © 2016 oisu. All rights reserved.
//

import UIKit
import PubNub
import Charts
import ObjectMapper


class ChartViewController: UIViewController {

    @IBOutlet fileprivate weak var chartView: ChartView!

    private var pubNubHandler = PubNubHandler()

    fileprivate var quoteType = QuoteType.getDefault()
    fileprivate var tickerPool: [Ticker] = []
    fileprivate var candleStickPool: [CandleStick] = []

    fileprivate var chartDataSet: IChartDataSet {
        get {
            let dataEntries = candleStickPool as [CandleChartDataEntry]
            let dataSet = CandleChartDataSet(values: dataEntries, label: "Ticker")

            dataSet.axisDependency = .left
            dataSet.shadowColor = UIColor.darkGray
            dataSet.shadowWidth = 0.7
            dataSet.decreasingColor = UIColor.red
            dataSet.decreasingFilled = true
            dataSet.increasingColor = UIColor.blue
            dataSet.increasingFilled = true
            dataSet.neutralColor = UIColor.black
            dataSet.drawValuesEnabled = false

            return dataSet as IChartDataSet
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure ChartView
        chartView.delegate = self
        chartView.xAxis.labelPosition = .bottom
        chartView.drawGridBackgroundEnabled = true
        chartView.chartDescription?.text = "Source: bitFlyer Lightning API"

        pubNubHandler.addHandler(listener: self)
    }
}

extension ChartViewController {

    fileprivate func updateChart(candleSticks: [CandleStick]) {
        chartView.data = CandleChartData(dataSets: [chartDataSet])
    }
    fileprivate func getXValue(timestamp: String) -> String? {
        return Util.Date.getTime(dateString: timestamp, format: Const.PubNub.dateFormat)
    }
    fileprivate func compareTimestamp(_ tickerA: Ticker, _ tickerB: Ticker) -> Bool {
        if let timestampA = tickerA.timestamp,
            let timestampB = tickerB.timestamp {
            return getXValue(timestamp: timestampA) == getXValue(timestamp: timestampB)
        }
        return false
    }
    fileprivate func getPrice(ticker: Ticker) -> Double? {
        switch quoteType {
        case .ask:
            return ticker.bestAsk
        case .bid:
            return ticker.bestBid
        }
    }
    fileprivate func getHighPrice() -> Double? {
        let prices = tickerPool.flatMap { getPrice(ticker: $0) }
        return prices.max()
    }
    fileprivate func getLowPrice() -> Double? {
        let prices = tickerPool.flatMap { getPrice(ticker: $0) }
        return prices.min()
    }

}

extension ChartViewController: PNObjectEventListener {

    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        guard
            let rawMessage = message.data.message,
            let jsonObject = rawMessage as? [String: Any] else {
                // TODO: Handle error
                return
        }
        Logger.print("Received message: \(rawMessage)")

        // Mapping
        guard let currentTicker = Mapper<Ticker>().map(JSON: jsonObject) else {
            // TODO: Handle error
            return
        }

        let openPrice = candleStickPool.last?.close ?? getPrice(ticker: currentTicker)

        // Make a candlestick and release tickerPool
        if let closeTicker = tickerPool.last,
            compareTimestamp(closeTicker, currentTicker),
            let highPrice = getHighPrice(),
            let lowPrice = getLowPrice(),
            let openPrice = openPrice,
            let closePrice = getPrice(ticker: closeTicker) {

            let candleStick = CandleStick(
                xValue: Double(candleStickPool.count),
                high: highPrice,
                low: lowPrice,
                open: openPrice,
                close: closePrice
            )

            candleStickPool.append(candleStick)
            tickerPool = [currentTicker]

            updateChart(candleSticks: candleStickPool)

        } else {
            tickerPool.append(currentTicker)
        }
    }
}

extension ChartViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        Logger.print("chartValueSelected")
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        Logger.print("chartValueNothingSelected")
    }
}
