//
//  ChartViewController.swift
//  bitFlyer
//
//  Created by Hiroaki Miura on 2016/10/05.
//  Copyright © 2016 oisu. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {

    @IBOutlet weak var chartView: ChartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        chartView.delegate = self
    }
}

extension ChartViewController: ChartViewDelegate {
    private func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        log.debug("chartValueSelected")
    }

    func chartValueNothingSelected(chartView: ChartViewBase) {
        log.debug("chartValueNothingSelected")
    }
}
