//
//  ContentView.swift
//  AssetManager
//
//  Created by Loki on 3/15/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var accounts: [Account]
    @Query var transactions: [Transaction]
    @State private var showingAddAccountSheet = false
    @State private var showingAddTransactionSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    HStack {
                        Text("$ \(accounts.reduce(0) { $0 + $1.balance }, specifier: "%.0f")")
                            .font(.largeTitle)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    
                    ForEach(AccountType.allCases, id: \.self) { type in
                        if !accounts.filter({ $0.type == type }).isEmpty {
                            Section(header: Text(type.rawValue)) {
                                accountSection(for: type)
                            }
                        }
                    }
                }
                .navigationTitle("淨資產")
            }
        }
        .onAppear {
            addInitialDataIfNeeded()
        }
    }
    
    private func accountSection(for type: AccountType) -> some View {
        ForEach(accounts.filter { $0.type == type }) { account in
            NavigationLink(destination: AccountView(
                modelContext: modelContext,
                account: account,
                transactions: transactions.filter { $0.accountId == account.id }
            )) {
                HStack {
                    Image(systemName: account.icon)
                        .font(.title)
                    Text(account.name)
                    Spacer()
                    Text("$ \(account.balance, specifier: "%.0f")")
                }
            }
        }
    }
    
    private func caculateAssetSummary() -> Double {
        accounts.reduce(0) { $0 + $1.balance }
    }
    
    private func caculateAccountBalances(account: Account) -> Double {
        transactions.filter { $0.accountId == account.id }
            .reduce(0) { $0 + $1.amount }
    }
    
    private func addInitialDataIfNeeded() {
        if accounts.isEmpty {
            let account1 = Account(name: "現金", icon: "💵", type: .currentAssets)
            let account2 = Account(name: "電子錢包", icon: "📱", type: .currentAssets)
            let account3 = Account(name: "投資", icon: "📈", type: .investments)
            let account4 = Account(name: "負債", icon: "💸", type: .liabilities)
            modelContext.insert(account1)
            modelContext.insert(account2)
            modelContext.insert(account3)
            modelContext.insert(account4)
            
            
            guard let salaryDate = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 19)),
                  let coffeeDate = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 20))
            else {
                fatalError("無法創建日期")
            }
            
            // 預先新增一些交易到第一個帳戶
            let transaction1 = Transaction(accountId: account1.id, amount: 27470.0, type: .income, notes: "薪水", date: salaryDate)
            let transaction2 = Transaction(accountId: account1.id, amount: -50.0, type: .expense, notes: "咖啡", date: coffeeDate)
            let transaction3 = Transaction(accountId: account1.id, amount: -30.0, type: .expense, notes: "麵包", date: coffeeDate)
            
            modelContext.insert(transaction1)
            modelContext.insert(transaction2)
            modelContext.insert(transaction3)
            
            account1.balance = caculateAccountBalances(account: account1)
            
            do {
                try modelContext.save()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Account.self, Transaction.self], inMemory: true)
}
