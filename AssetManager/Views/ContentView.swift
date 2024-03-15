//
//  ContentView.swift
//  AssetManager
//
//  Created by Loki on 3/15/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var viewModel = AssetManagerViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var isAmountHidden = false // 新增狀態變量跟蹤資產額度是否隱藏
    @State private var showingAddAccountSheet = false // 控制添加帳戶表單顯示的狀態
    @State private var selectedAccount: Account?
    
    var body: some View {
        NavigationView {
            VStack {
                // 顯示資產總額
                Button(action: {
                    isAmountHidden.toggle()
                }) {
                    if isAmountHidden {
                        Text("*****")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    } else {
                        Text("$  \(viewModel.totalAssets, specifier: "%.0f")")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // 顯示帳戶列表
                List {
                    ForEach(viewModel.accounts) { account in
                        HStack {
                            Text("\(account.icon)  \(account.name)")
                            Spacer()
                            Text("\(account.balance, specifier: "%.0f")")
                        }
                        .padding(.vertical, 10)
                        .onTapGesture {
                            selectedAccount = account
                        }
                    }
                }
                .toolbar {
                    ToolbarItemGroup {
                        Button(action: {
                            showingAddAccountSheet = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddAccountSheet) {
                    
                    AddAccountView(viewModel: viewModel, isPresented: $showingAddAccountSheet)
                }
                .sheet(item: $selectedAccount) { account in
                    AccountView(account: account, transactions: viewModel.transactions.filter { $0.accountId == account.id }, selectedAccount: $selectedAccount)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
