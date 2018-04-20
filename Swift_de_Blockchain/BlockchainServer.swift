//
//  BlockchainServer.swift
//  Swift_de_Blockchain
//
//  Created by Hinomori Hiroya on 2018/04/20.
//  Copyright © 2018年 Hinomori Hiroya. All rights reserved.
//

import UIKit

class BlockchainServer: NSObject {
    let blockchain = Blockchain()
    
    func mine(sender: String) -> Block {
        let proof = blockchain.proofOfWork()
        _ = blockchain.createTransaction(sender: sender,
                                         recipient: "blockchain.server",
                                         amount: 1)
        return blockchain.createBlock(proof: proof)
    }
    func fullchain() -> Dictionary<String, Any> {
        return ["chain": blockchain.chain, "length": blockchain.chain.count]
    }
}
