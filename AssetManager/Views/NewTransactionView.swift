//
//  NewTransactionView.swift
//  AssetManager
//
//  Created by Loki on 3/17/24.
//

import SwiftUI
import SwiftData

struct NewTransactionView: View {
    var modelContext: ModelContext
    var account: Account
    var dismiss: () -> Void
    
    @State private var amount: String = ""
    @State private var type: TransactionType = .expense
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("$")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    TextField("", text: $amount)
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("備註")
                        .opacity(0.5)
                    
                    TextField("增減金額", text: $notes) // 使用TextField
                        .multilineTextAlignment(.trailing) // 使文本靠右对齐
                }
                .padding(.horizontal)
                
                Picker("Type", selection: $type) {
                    ForEach(TransactionType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                Spacer()
            }
            .navigationTitle("新增交易")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button{
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button{
                        if !amount.isEmpty {
                            saveTransaction()
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .disabled(amount.isEmpty)
                    }
                }
            }
        }
    }
    
    private func saveTransaction() {
        let transaction = Transaction(
            accountId: account.id,
            amount: Double(amount) ?? 0.0,
            type: type,
            notes: notes == "" ? "增減金額" : notes
        )
        modelContext.insert(transaction)
        account.balance += type == .expense ? -transaction.amount : transaction.amount
        try? modelContext.save()
        dismiss()
    }
}
