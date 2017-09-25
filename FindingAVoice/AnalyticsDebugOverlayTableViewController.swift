//
//  AnalyticsDebugOverlayTableViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 25/09/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

extension IndexPath {
    static let zero = IndexPath(row: 0, section: 0)
}

class AnalyticsDebugOverlayTableViewController: UITableViewController {

    var data = [String]() {
        didSet {
            tableView.insertRows(at: [.zero], with: .automatic)
            tableView.scrollToRow(at: .zero, at: .top, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.alpha = 0.5
        view.isUserInteractionEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            assertionFailure("Couldn't dequeue cell")
            return UITableViewCell()
        }
        cell.isUserInteractionEnabled = false
        cell.textLabel?.textColor = .red
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.backgroundColor = .clear

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = data[indexPath.item]
    }
    
}
