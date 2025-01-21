//
//  DatabaseTestView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/21.
//

import SwiftUI

struct DatabaseTestView: View {
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var users: [(Int64, String, Int)] = []
    
    var body: some View {
        VStack {
            // 输入表单
            HStack {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Age", text: $age)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                Button(action: addUser) {
                    Text("Add User")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding()
            
            // 用户列表
            List(users, id: \.0) { user in
                HStack {
                    Text("ID: \(user.0)")
                    Spacer()
                    Text("\(user.1), \(user.2) years old")
                }
            }
        }
        .onAppear(perform: fetchUsers)
    }
    
    private func addUser() {
        guard let userAge = Int(age), !name.isEmpty else { return }
        DatabaseManager.shared.insertUser(name: name, age: userAge)
        fetchUsers()
        name = ""
        age = ""
    }
    
    private func fetchUsers() {
        users = DatabaseManager.shared.fetchUsers()
    }
}
