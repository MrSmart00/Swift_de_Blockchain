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
        return Data(bytes: hash)
    }
}

struct Block: Codable {
    let index: Int
    let timestamp: Double
    let transactions: [Transaction]!
    let proof: Int
    let previousHash: Data!
    
    var description: String {
        get {
            let json = try! JSONEncoder().encode(self)
            return String(data: json, encoding: .utf8)!
        }
    }
}

struct Transaction: Codable {
    let sender: String!
    let recipient: String!
    let amount: Int
    
    var description: String {
        get {
            let json = try! JSONEncoder().encode(self)
            return String(data: json, encoding: .utf8)!
        }
    }
}

class Blockchain {
    
    var currentTransactions: [Transaction] = []
    var chain: [Block] = []
    
    init() {
        _ = createBlock(proof: 0, previousHash: "0".data(using: .utf8))
    }
    
    func createBlock(proof: Int, previousHash: Data? = nil) -> Block {
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
    
    func proofOfWork() -> Int {
        var nance: Int = 0
        var lastProof: Int = lastBlock().proof
        while validProof(proof: lastProof, nance: nance) == false {
            lastProof = lastBlock().proof
            nance += 1
        }
        return nance
    }
    
    fileprivate func validProof(proof: Int, nance: Int) -> Bool {
        if let hash = String(format: "%d*%d", proof, nance).data(using: .utf8)?.sha256() {
            let hexdigest: String = hash.map { String(format: "%.2hhx", $0) }.joined()
            return String(hexdigest.prefix(4)) == "0000"
        }
        return false
    }
}
