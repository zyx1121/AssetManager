//
//  AddAccountView.swift
//  AssetManager
//
//  Created by Loki on 3/15/24.
//

import SwiftUI

struct AddAccountView: View {
    @ObservedObject var viewModel: AssetManagerViewModel
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var selectedType: AccountType = .currentAssets
    
    var body: some View {
        NavigationView {
            Form {
                TextField("帳戶名稱", text: $name)
                TextField("帳戶圖示", text: $icon)
                Picker("帳戶類型", selection: $selectedType) {
                    ForEach(AccountType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("新增帳戶")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("儲存") {
                        // 執行新增帳戶的邏輯
                        let newAccount = Account(name: name, icon: icon, type: selectedType)
                        viewModel.accounts.append(newAccount)
                        isPresented = false
                    }
                }
            }
        }
    }
}
