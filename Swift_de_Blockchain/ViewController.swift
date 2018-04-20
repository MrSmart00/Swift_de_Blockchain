//
//  ViewController.swift
//  Swift_de_Blockchain
//
//  Created by Hinomori Hiroya on 2018/04/19.
//  Copyright © 2018年 Hinomori Hiroya. All rights reserved.
//

import UIKit

extension CALayer {
    var borderUIColor: UIColor? {
        get {
            if self.borderColor != nil {
                return UIColor(cgColor: self.borderColor!)
            } else {
                return nil
            }
        }
        set {
            self.borderColor = newValue?.cgColor
        }
    }
}

class MinerCell: UITableViewCell {
    
    var dispatchGroup: DispatchGroup!
    @IBOutlet private weak var activityView: UIActivityIndicatorView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    private let queue: DispatchQueue = DispatchQueue(label: String(format: "miner[%@]", NSUUID().uuidString))
    var server: BlockchainServer? {
        didSet {
            nameLabel.text = queue.label
            statusLabel.text = "Mining"
            dateLabel.text = ""
            queue.async(group: dispatchGroup) {
                let startDate: Date = Date()
                if let server = self.server {
                    let block = server.mine(sender: self.queue.label)
                    DispatchQueue.main.async {
                        let formatter: DateFormatter = DateFormatter()
                        formatter.dateFormat = "HH:mm:ss"
                        formatter.locale = Locale(identifier: "ja_JP")
                        let interval: TimeInterval = startDate.timeIntervalSince(Date())
                        let finishDate: Date = Date(timeIntervalSince1970: -interval)
                        self.dateLabel.text = formatter.string(from: finishDate)
                        print(self.queue.label, interval)
                        self.statusLabel.text = "Complete"
                        self.activityView.isHidden = true
                    }
                }
            }
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    let miner: Int = 3
    let trader: Int = 10
    let server = BlockchainServer()
    var dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("ALL COMPLETE!!!")
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return miner
        } else {
            return trader
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.section == 0 {
            let minerCell = tableView.dequeueReusableCell(withIdentifier: "MinerCell") as! MinerCell
            minerCell.server = server
            minerCell.dispatchGroup = dispatchGroup
            cell = minerCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "TraderCell")
        }
        if cell == nil {
            cell = UITableViewCell()
        }
        return cell!
    }
}
