//
//  Blockchain.swift
//  Swift_de_BlockChain
//
//  Created by Hinomori Hiroya on 2018/04/19.
//  Copyright © 2018年 Hinomori Hiroya. All rights reserved.
//

import Foundation

extension Data {
    func sha256() -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(self.count), &hash)
        }
        print(hash)
        return Data(bytes: hash)
    }
}

struct Block: Codable {
    let index: Int
    let timestamp: Double
    let transactions: [Transaction]!
    let proof: Int
    let previousHash: Data!
}

struct Transaction: Codable {
    let sender: String!
    let recipient: String!
    let amount: Int
}

class Blockchain {
    
    var currentTransactions: [Transaction] = []
    var chain: [Block] = []
    
    init() {
        _ = createBlock(proof: 0, previousHash: "0".data(using: .utf8))
    }
    
    func createBlock(proof: Int, previousHash: Data?) -> Block {
        let pHash: Data
        if let prevHash = previousHash {
            pHash = prevHash
        } else {
            pHash = hash(block: lastBlock())
        }
        let block: Block = Block(index: chain.count + 1,
                                 timestamp: Date().timeIntervalSince1970,
                                 transactions: currentTransactions,
                                 proof: proof,
                                 previousHash: pHash)
        currentTransactions = []
        chain.append(block)
        return block
    }
    
    func createTransaction(sender: String!, recipient: String!, amount: Int) -> Int {
        let transaction: Transaction = Transaction(sender: sender,
                                                   recipient: recipient,
                                                   amount: amount)
        currentTransactions.append(transaction)
        return lastBlock().index + 1
    }
    
    func hash(block: Block) -> Data {
        let encoder = JSONEncoder()
        let data: Data = try! encoder.encode(block)
        return data.sha256()
    }
    
    func lastBlock() -> Block {
        guard let last: Block = chain.last else { fatalError("Nothing Last Block.") }
        return last
    }
    
    func proofOfWork(lastProof: Int) -> Bool {
        let hash = Data(count: lastProof).sha256()
        let digest: String = hash.map { String(format: "%.2hhx", $0) }.joined()
        print(digest)
        let lastDigestNumber: String = String(digest.prefix(4))
        print(lastDigestNumber)
        return lastDigestNumber == "0000"
    }
}
