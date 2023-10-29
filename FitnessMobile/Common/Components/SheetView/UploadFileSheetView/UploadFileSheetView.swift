//
//  UploadFileSheetView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 22/10/2023.
//

import SwiftUI
import PhotosUI

struct UploadFileSheetView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isCameraPresented = false
    @State private var imageFromCamera: UIImage? = nil
    
    var onImage: ((Data?, Int?, Dimensions?) -> Void)
    
    var body: some View {
        VStack {
            Text("_WORKSPACE_UPLOAD_DOCUMENT_TITLE")
                .padding()
                .font(.title)
                .foregroundColor(Color.Neutral.tone80)
            Text("_WORKSPACE_UPLOAD_DOCUMENT_SUBTITLE")
                .font(.subheadline)
                .foregroundColor(Color.Neutral.tone80)
            Spacer()
            HStack {
               Buttons()
            }
        }
        .onChange(of: selectedItem) { _ in
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                    onImage(data, data.count, Dimensions(width: 15, height: 15))
                } else {
                    onImage(nil, nil, nil)
                }
            }
        }
        .onChange(of: imageFromCamera, perform: { value in
            if let image = imageFromCamera,
               let data = image.pngData() {
                onImage(data, data.count, Dimensions(width: 15, height: 15))
            } else {
                onImage(nil, nil, nil)
            }
        })
        .sheet(isPresented: $isCameraPresented, content: {
            ImagePicker(sourceType: .camera, selectedImage: $imageFromCamera)
        })
        .padding()
    }
    
    func Buttons() -> some View {
        return HStack(spacing: 16) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    HStack{
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("From Gallery")
                            .font(.subheadline)
                        
                    }
                    .padding()
                    .background(Color.Dark.tone90)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    
                }
            
            HStack{
                Image(systemName: "camera")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("New Photo")
                    .font(.subheadline)
            }
            .padding()
            .background(Color.Dark.tone90)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .onTapGesture {
                isCameraPresented = true
            }
        }
    }
}

#Preview {
    UploadFileSheetView { image, size, dimensions in
        
    }
}
