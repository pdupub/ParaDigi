//
//  PrivateKeyLoginView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/14.
//

import SwiftUI

struct PrivateKeyLoginView: View {
    @State private var privateKey: String = ""
    @State private var errorMessage: String? = nil
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Enter your private key")
                    .font(.largeTitle)
                    .padding()
                
                // Multi-line input field using TextEditor
                TextEditor(text: $privateKey)
                    .frame(height: 150) // 设置文本框高度
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .border(privateKey.count == 64 ? Color.gray : Color.red, width: 1) // 输入框颜色根据私钥长度变化
                
                // Error message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Login button
                Button(action: login) {
                    Text("Log In")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: 400)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                // Success message
                if isLoggedIn {
                    Text("Login successful!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Private Key Login")
            .padding()
        }
    }
    
    // Login logic
    private func login() {
        // Clear error message
        errorMessage = nil
        
        // Validate private key length
        if privateKey.count == 64 {
            // You can perform actual authentication or encryption logic here
            isLoggedIn = true
        } else {
            // Show error message if the private key length is invalid
            errorMessage = "Invalid private key length, it must be 64 characters"
            isLoggedIn = false
        }
    }
}

struct PrivateKeyLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateKeyLoginView()
    }
}
