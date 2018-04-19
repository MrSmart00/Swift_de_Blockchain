//
//  ViewController.swift
//  Swift_de_Blockchain
//
//  Created by Hinomori Hiroya on 2018/04/19.
//  Copyright © 2018年 Hinomori Hiroya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue(label: "blockchain.proof.queue").async {
            var proof = 0
            let blockChain: Blockchain = Blockchain()
            while blockChain.proofOfWork(lastProof: proof) == false {
                proof += 1
            }
            // メインスレッドで実行
            DispatchQueue.main.async {
                print("PROOOOF : " + String(proof))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

