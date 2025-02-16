import SwiftUI
import SwiftData

struct PostContentView: View {
    @Environment(\.dismiss) private var dismiss // 用于关闭页面
    @Environment(\.modelContext) private var modelContext // 获取数据上下文
    @FocusState private var isFocused: Bool // 控制焦点状态
    @StateObject private var viewModel = PostContentViewModel()

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
                    TextEditor(text: $viewModel.textContent)
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
                viewModel.setModelContext(modelContext: modelContext)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        viewModel.saveItem()
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

}
