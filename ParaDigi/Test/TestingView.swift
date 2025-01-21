//
//  TestingView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct TestingView: View {
    @State private var email = "" // 存储用户输入的 Email
    @State private var password = "" // 存储用户输入的 Password
    @State private var errorMessage = "" // 显示错误信息
    @State private var isSuccess = false // 注册是否成功
    @State private var databaseMessage = "" // 从数据库读取的数据
    @State private var inputDatabaseText = "" // 写入数据库的内容
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            Button(action: registerUser) {
                Text("Register")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            if isSuccess {
                Text("Registration Successful!")
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Divider().padding(.vertical)
            
            // Database Interaction
            Text("Firebase Database Example")
                .font(.headline)
            
            TextField("Enter text to save to database", text: $inputDatabaseText)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            Button(action: writeToDatabase) {
                Text("Save to Database")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            
            Button(action: readFromDatabase) {
                Text("Read from Database")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            
            if !databaseMessage.isEmpty {
                Text("Database Message: \(databaseMessage)")
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding()
    }
    
    private func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                isSuccess = false
            } else {
                errorMessage = ""
                isSuccess = true
            }
        }
    }
    
    private func writeToDatabase() {
        let db = Firestore.firestore() // 获取 Firestore 数据库实例
        let data: [String: Any] = [
            "text": inputDatabaseText,
            "timestamp": Timestamp(date: Date()) // 添加时间戳
        ]
        
        db.collection("examples").addDocument(data: data) { error in
            if let error = error {
                databaseMessage = "Error writing to Firestore: \(error.localizedDescription)"
            } else {
                databaseMessage = "Successfully wrote to Firestore"
            }
        }
    }
    
    private func readFromDatabase() {
        let db = Firestore.firestore() // 获取 Firestore 数据库实例
        
        db.collection("examples").order(by: "timestamp", descending: true).limit(to: 1).getDocuments { snapshot, error in
            if let error = error {
                databaseMessage = "Error reading from Firestore: \(error.localizedDescription)"
            } else if let snapshot = snapshot, !snapshot.isEmpty, let data = snapshot.documents.first?.data() {
                if let text = data["text"] as? String {
                    inputDatabaseText = text
                    databaseMessage = "Read from Firestore"
                } else {
                    databaseMessage = "No valid data found"
                }
            } else {
                databaseMessage = "No documents found in Firestore"
            }
        }
    }
}
