//
//  Account.swift
//  AssetManager
//
//  Created by Loki on 3/15/24.
//

import Foundation
import SwiftData

enum AccountType: String, CaseIterable, Codable {
    case currentAssets = "流動資金"
    case investments = "投資"
    case fixedAssets = "固定資產"
    case receivables = "應收款項"
    case liabilities = "負債"
}

class Account: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var icon: String
    var type: AccountType
    var balance: Double = 0.0
    
    init(name: String, icon: String, type: AccountType) {
        self.name = name
        self.icon = icon
        self.type = type
    }
}
