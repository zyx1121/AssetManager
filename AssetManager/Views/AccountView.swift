//
//  AccountView.swift
//  AssetManager
//
//  Created by Loki on 3/15/24.
//

import SwiftUI
import SwiftData

struct AccountView: View {
    var modelContext: ModelContext
    var account: Account
    var transactions: [Transaction]
    @State private var showingNewTransactionSheet = false
    
    private var transactionsGroupedByDate: [String: [Transaction]] {
        let groupedTransactions = Dictionary(grouping: transactions) { transaction -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d" // "MMM d" 例如：Jan 5
            return dateFormatter.string(from: transaction.date)
        }
        return groupedTransactions
    }
    
    private var sortedDates: [String] {
        transactionsGroupedByDate.keys.sorted { date1, date2 in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d" // 用于比较的日期格式需与上面一致
            guard let date1 = dateFormatter.date(from: date1), let date2 = dateFormatter.date(from: date2) else { return false }
            return date1 > date2
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    HStack {
                        Text("$ \(account.balance, specifier: "%.0f")")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    
                    ForEach(sortedDates, id: \.self) { dateString in
                        Section(header: Text(dateString)) {
                            ForEach(transactionsGroupedByDate[dateString] ?? []) { transaction in
                                HStack {
                                    Text(transaction.notes)
                                    Spacer()
                                    Text("\(transaction.amount, specifier: "%.f")")
                                        .foregroundColor(transaction.type == .income ? .green : .red)
                                }
                            }
                        }
                    }
                }
                .navigationTitle(account.name)
                
                VStack {
                    Spacer()
                    Button(action: {
                        showingNewTransactionSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding()
                    }
                    .background(Color.primary)
                    .foregroundStyle(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                .shadow(radius: 20)
            }
        }
        .sheet(isPresented: $showingNewTransactionSheet) {
            // 假设 NewTransactionView 接受一个 account 对象和一个用于关闭 sheet 的闭包
            NewTransactionView(
                modelContext: modelContext,
                account: account,
                dismiss: {
                    showingNewTransactionSheet = false
                }
            )
        }
    }
}
