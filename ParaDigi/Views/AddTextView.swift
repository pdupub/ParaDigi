import SwiftUI
import SwiftData

struct AddTextView: View {
    @State private var textContent = "" // 存储输入的文字内容
    @Environment(\.dismiss) private var dismiss // 用于关闭页面
    @Environment(\.modelContext) private var modelContext // 获取数据上下文
    @FocusState private var isFocused: Bool // 控制焦点状态

    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .top) { // 设置对齐方式为顶部对齐
                    // 头像区域，使用 SFSymbol 图标
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray) // 设置头像的颜色
                        .clipShape(Circle()) // 圆形头像

                    // TextEditor 输入框
                    TextEditor(text: $textContent)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .focused($isFocused) // 绑定焦点状态
                }
                .padding() // 给 HStack 添加一些内边距

                Spacer()
            }
            .onAppear {
                // 当视图出现时，自动使 TextEditor 获取焦点
                isFocused = true
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        saveItem()
                        dismiss()
                    }
                    .foregroundColor(Color.primary)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.primary)
                }
            }
        }
    }

    private func saveItem() {

        // 添加数据
        let newContent = QContent(data: AnyCodable(textContent), format: "txt")
        modelContext.insert(newContent)

        let newQuantum = UnsignedQuantum(contents: [newContent], last: "0x12345", nonce: 123, references: ["0x5678"], type: 1)
        modelContext.insert(newQuantum)
    }
}
