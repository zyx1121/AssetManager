//
//  Transaction.swift
//  AssetManager
//
//  Created by Loki on 3/15/24.
//

import Foundation
import SwiftData

enum TransactionType: String, Codable {
    case income = "收入"
    case expense = "支出"
}

struct Transaction: Identifiable, Codable {
    var id: UUID = UUID()
    var accountId: UUID
    var amount: Double
    var type: TransactionType
    var notes: String
    var date: Date
    
    init(accountId: UUID, amount: Double, type: TransactionType, notes: String, date: Date = Date()) {
        self.accountId = accountId
        self.amount = amount
        self.type = type
        self.notes = notes
        self.date = date
    }
}
