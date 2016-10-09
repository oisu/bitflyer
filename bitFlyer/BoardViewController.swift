//
//  BoardViewController.swift
//  bitFlyer
//
//  Created by Hiroaki Miura on 2016/10/05.
//  Copyright © 2016 oisu. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

class BoardViewController: UIViewController {

    fileprivate var boardData: Board?
    fileprivate var quoteType = QuoteType.getDefault()

    @IBOutlet fileprivate weak var boardTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BoardViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // swiftlint:disable force_cast
        let headerView = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")?.contentView
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}

extension BoardViewController: UITableViewDataSource {

    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let boardData = boardData,
            let quotes = boardData.getQuotes(quoteType: quoteType) {
            return quotes.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        // swiftlint:disable force_cast
        let quoteCell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as! QuoteCell

        if let boardData = boardData,
            let quote = boardData.getQuotes(quoteType: quoteType)?[row],
            let price = quote.price,
            let size = quote.size {
            quoteCell.priceLabel.text = "\(price)"
            quoteCell.sizeLabel.text = "\(size)"
        }
        return quoteCell
    }
}

extension BoardViewController {
    fileprivate enum RowType: Int {
        case header
        case quote
    }

    fileprivate func refresh() {
        let url = Const.Api.endpoint + Const.Api.getBoard

        RequestHandler.request(urlString: url) { [weak self] result in
            switch result {

            case .success(let result):
                // Mapping
                guard
                    let jsonString = result as? Dictionary<String, Any>,
                    let board = Mapper<Board>().map(JSON: jsonString) else {
                    // TODO: Handle error
                    return
                }
                self?.boardData = board
                self?.boardTableView.reloadData()

                Logger.print(board)

            case .failure(let error):
                // TODO: Handle error
                Logger.print(error)
            }
        }
    }
}
