//
//  AssetManagerViewModel.swift
//  AssetManager
//
//  Created by Loki on 3/15/24.
//

import Combine
import Foundation

class AssetManagerViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var transactions: [Transaction] = []
    @Published var totalAssets: Double = 0.0
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        loadSampleData()
        
        // 監聽帳戶和交易的變化，並重新計算餘額
        Publishers.CombineLatest($transactions, $accounts)
            .sink { [weak self] (_, _) in
                self?.calculateBalances()
                self?.calculateTotalAssets()
            }
            .store(in: &cancellables)
    }
    
    func loadSampleData() {
        // 預先新增一些帳戶
        let account1 = Account(name: "流動資金", icon: "💰", type: .currentAssets)
        let account2 = Account(name: "投資", icon: "📈", type: .investments)
        accounts.append(contentsOf: [account1, account2])
        
        // 預先新增一些交易到第一個帳戶
        let transaction1 = Transaction(accountId: account1.id, amount: 27470.0, type: .income, notes: "薪水", date: Date())
        let transaction2 = Transaction(accountId: account1.id, amount: -50.0, type: .expense, notes: "咖啡", date: Date())
        transactions.append(contentsOf: [transaction1, transaction2])
        
        // 更新資產總額
        calculateTotalAssets()
    }
    
    func calculateBalances() {
        accounts.forEach { $0.balance = 0.0 }
        
        for transaction in transactions {
            if let index = accounts.firstIndex(where: { $0.id == transaction.accountId }) {
                accounts[index].balance += transaction.amount
            }
        }
    }
    
    func calculateTotalAssets() {
        totalAssets = accounts.reduce(0) { $0 + $1.balance }
    }
}
