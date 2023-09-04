//
//  PhotoPickerView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 26/08/2023.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var photoPickerManager = PhotoPickerManager()
    @State private var selectedItem: PhotosPickerItem?
    @EnvironmentObject var coordinator: Coordinator
    
    @State private var isCameraPresented = false
    @State private var imageFromCamera: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), center: .center, startRadius: 0, endRadius: geometry.size.width)
                    .ignoresSafeArea()
                
                VStack {
                    HeaderView()
                    Spacer()
                    PhotoView(geometry: geometry)
                        .padding(.bottom)
                    Buttons()
                    Spacer()
                }
            }
        }
        
        .onAppear {
            photoPickerManager.fetchProfileImage()
        }
        .onChange(of: selectedItem) { _ in
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data),
                   let compressedData = image.jpegData(compressionQuality: 0.1) {
                    print("Original Image Sized: \(data.count)")
                    print("Compressed Image Sized: \(compressedData.count)")
                    photoPickerManager.imageData = compressedData
                } else {
                    photoPickerManager.imageData = nil
                }
            }
        }
        .onChange(of: imageFromCamera, perform: { value in
            if let image = imageFromCamera,
               let compressedData = image.jpegData(compressionQuality: 0.1) {
                print("Compressed Image Sized: \(compressedData.count)")
                photoPickerManager.imageData = compressedData
            }
        })
        .onReceive(photoPickerManager.$imageUploaded) { value in
            if value {
                dismiss()
            }
        }
        .overlay(
            Group {
                CustomAlertView(isPresented: $photoPickerManager.showError, title: $photoPickerManager.errorTitle, message: $photoPickerManager.errorMessage)
                CustomProgressView(isLoading: $photoPickerManager.isLoading)
            }
        )
        .sheet(isPresented: $isCameraPresented, content: {
            if isCameraPresented {
                ImagePicker(sourceType: .camera, selectedImage: $imageFromCamera)
            }
        })
    }
    
    func HeaderView() -> some View {
        return VStack {
            HStack {
                Button("_CANCEL_BUTTON") {
                    dismiss()
                }
                .foregroundColor(.accentColor)
                Spacer()
                Button("_SAVE_BUTTON") {
                    photoPickerManager.uploadImage()
                }
                .foregroundColor(.accentColor)
                
            }
            .padding()
            .padding(.horizontal)
        }
    }
    
    func PhotoView(geometry: GeometryProxy) -> some View {
        return VStack {
            photoPickerManager.getImageView()
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                }
        }
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

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView()
    }
}
