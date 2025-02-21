import SwiftUI
import PhotosUI

struct PostFeedView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isFocused: Bool
    @StateObject private var viewModel = PostViewModel()
    
    @State private var selectedImages: [UIImage] = [] // 用于保存选中的图片
    @State private var showImagePicker = false // 控制图片选择器显示
    @State private var isImagePickerPresented = false // 用于显示 PHPickerViewController

    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .top) {
                    AvatarView(avatarBase64: viewModel.fetchDefaultUserInfo(modelContext: modelContext)?["avatar"]?.displayText)
                    
                    ZStack(alignment: .topLeading) {
                        
                        TextEditor(text: $viewModel.textContent)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .focused($isFocused)
                        if viewModel.textContent.isEmpty {
                            Text("Enter your post here...")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 8)
                        }
                    }
                }
                .padding()
                
                // 图片选择按钮
                HStack {
                    Button(action: {
                        isImagePickerPresented.toggle() // 展开图片选择器
                    }) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.title)
                            .padding()
                            .background(Color.blue.opacity(0.1), in: Circle())
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        PhotoPicker(selectedImages: $selectedImages)
                    }
                }
                .padding(.top)
                
                // 显示选中的图片
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(4)
                        }
                    }
                }
                
                Spacer()
            }
            .onAppear {
                isFocused = true
                viewModel.setModelContext(modelContext: modelContext)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        viewModel.saveItem(images: selectedImages) // 传递图片
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

struct PhotoPicker: View {
    @Binding var selectedImages: [UIImage]
    
    var body: some View {
        PHPickerViewControllerWrapper(selectedImages: $selectedImages)
    }
}

struct PHPickerViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 4 // 限制最多选择4张图片
        config.filter = .images // 仅允许选择图片
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImages: $selectedImages)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        @Binding var selectedImages: [UIImage]
        
        init(selectedImages: Binding<[UIImage]>) {
            _selectedImages = selectedImages
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            var images: [UIImage] = []
            
            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        images.append(image)
                    }
                    if images.count == results.count {
                        DispatchQueue.main.async {
                            self.selectedImages = images
                        }
                    }
                }
            }
        }
    }
}
