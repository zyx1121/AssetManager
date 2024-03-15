//
//  AccountView.swift
//  AssetManager
//
//  Created by Loki on 3/15/24.
//

import SwiftUI

struct AccountView: View {
    var account: Account
    var transactions: [Transaction]
    @Binding var selectedAccount: Account?
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("$  \(account.balance, specifier: "%.0f")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                List {
                    ForEach(transactions) { transaction in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(transaction.notes)
                                Text(dateFormatter.string(from: transaction.date))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("\(transaction.amount, specifier: "%.f")")
                                .foregroundColor(transaction.type == .income ? .green : .red)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("\(account.icon)  \(account.name)")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}
