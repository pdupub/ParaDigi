import SwiftUI

struct CryptoTestView: View {
    @State private var privateKey: String = "" // 显示生成的私钥
    @State private var publicKey: String = "" // 显示生成的公钥
    @State private var address: String = "" // 显示生成的地址
    @State private var message: String = "Hello, Swift Crypto!" // 用户输入的消息
    @State private var signature: String = "" // 显示生成的签名
    @State private var verificationResult: String = "" // 签名验证结果
    @State private var copyMessage: String = "" // 显示复制成功的信息

    
    @Environment(\.modelContext) private var modelContext // 获取数据上下文

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Swift Crypto Test")
                    .font(.largeTitle)
                    .bold()
                Button("Verify Signed Quantum") {
                    verifySignedQuantum()
                }

//                Button("Generate Keys & Address") {
//                    generateKeysAndAddress()
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)

                Group {
                    ClickableText(title: "Private Key:", content: privateKey)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    ClickableText(title: "Public Key:", content: publicKey)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    ClickableText(title: "Address:", content: address)
                }

                Divider()

                TextField("Enter message to sign", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

//                Button("Sign Message") {
//                    signMessage()
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.green)
//                .foregroundColor(.white)
//                .cornerRadius(8)

                ClickableText(title: "Signature:", content: signature)
                    .lineLimit(1)
                    .truncationMode(.middle)

//                Button("Verify Signature") {
//                    verifySignature()
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.orange)
//                .foregroundColor(.white)
//                .cornerRadius(8)

                Text("Verification Result:")
                    .font(.headline)
                Text(verificationResult)
                    .foregroundColor(verificationResult == "Valid" ? .green : .red)

                if !copyMessage.isEmpty {
                    Text(copyMessage)
                        .foregroundColor(.blue)
                        .font(.caption)
                        .padding(.top, 10)
                        .transition(.opacity)
                }
            }
            .onAppear{
                generateKeysAndAddress()
//                signMessage()
//                verifySignature()
            }
            .padding()
        }
    }

    private func generateKeysAndAddress() {
        let privateKeyData = CompatibleCrypto.generatePrivateKey()
        privateKey = privateKeyData.map { String(format: "%02x", $0) }.joined()

        let publicKeyData = CompatibleCrypto.generatePublicKey(privateKey: privateKeyData)
        publicKey = publicKeyData!.map { String(format: "%02x", $0) }.joined()

        address = CompatibleCrypto.generateAddress(publicKey: publicKeyData!)
    }

    private func signMessage() {
        guard let privateKeyData = Data(hex: privateKey) else { return }
        guard let messageData = message.data(using: .utf8) else { return }

        let signatureData = CompatibleCrypto.signMessage(privateKey: privateKeyData, message: messageData)
        signature = signatureData!.map { String(format: "%02x", $0) }.joined()
    }

    private func verifySignature() {
        guard let publicKeyData = Data(hex: publicKey) else { return }
        guard let messageData = message.data(using: .utf8) else { return }

        guard let signatureData = Data(hex: signature) else { return }
        let address = CompatibleCrypto.generateAddress(publicKey: publicKeyData)

        let isValid = CompatibleCrypto.verifySignature(message: messageData, signature: signatureData, address: address)
        verificationResult = isValid ? "Valid" : "Invalid"
    }
    
    private func verifySignedQuantum() {
        var qs : [QContent] = []
        qs.append(QContent(order: 0, data: AnyCodable(message), format: "str"))
        qs.append(QContent(order: 1, data: AnyCodable(123), format: "int"))
        
        guard let signedQuantum = QuantumManager.createSignedQuantum(qs, qtype: 0, modelContext: modelContext) else { return }
        let isValid = QuantumManager.verifyQuantumSignature(signedQuantum)
        verificationResult = isValid ? "Valid" : "Invalid"
    }
}

// 子视图：实现点击复制的功能
struct ClickableText: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            Text(content)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundColor(.gray)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .onTapGesture {
                    UIPasteboard.general.string = content // 复制到剪贴板
                }
        }
    }
}

extension Data {
    init?(hex: String) {
        let bytes = stride(from: 0, to: hex.count, by: 2).compactMap { i -> UInt8? in
            let start = hex.index(hex.startIndex, offsetBy: i)
            let end = hex.index(start, offsetBy: 2, limitedBy: hex.endIndex) ?? hex.endIndex
            return UInt8(hex[start..<end], radix: 16)
        }
        self.init(bytes)
    }
}
