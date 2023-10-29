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
    @StateObject var viewmodel = PhotoPickerManager()
    @State private var selectedItem: PhotosPickerItem?
    @EnvironmentObject var coordinator: Coordinator
    
    @State private var isCameraPresented = false
    @State private var imageFromCamera: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    PhotoView(geometry: geometry)
                        .padding(.bottom)
                    Spacer()
                    Buttons()
                    Spacer()
                }
            }
        }
        .navigationBarItems(trailing: CustomNavigationButton(action: {
            if viewmodel.imageData != nil {
                viewmodel.uploadImage()
            } else {
                viewmodel.removeImage()
            }
        }, title: "_SAVE_IMAGE"))
        .onAppear {
            viewmodel.fetchProfileImage()
        }
        .onChange(of: selectedItem) { _ in
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                    viewmodel.imageData = data
                } else {
                    viewmodel.imageData = nil
                }
            }
        }
        .onChange(of: imageFromCamera, perform: { value in
            if let image = imageFromCamera,
               let imageData = image.jpegData(compressionQuality: 1) {
                viewmodel.imageData = imageData
            }
        })
        .onReceive(viewmodel.$imageUploaded) { value in
            if value {
                dismiss()
            }
        }
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
        .sheet(isPresented: $isCameraPresented, content: {
            if isCameraPresented {
                ImagePicker(sourceType: .camera, selectedImage: $imageFromCamera)
            }
        })
    }
    
    func PhotoView(geometry: GeometryProxy) -> some View {
        return VStack {
            viewmodel.getImageView()
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
        return HStack(spacing: 32) {
            VStack{
                Image(systemName: "camera")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("_REMOVE_IMAGE")
                    .font(.subheadline)
            }
            .padding()
            .background(Color.Dark.tone90)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .onTapGesture {
                viewmodel.imageData = nil
            }
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    VStack{
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("_GALLERY")
                            .font(.subheadline)
                        
                    }
                    .padding()
                    .background(Color.Dark.tone90)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    
                }
            
            VStack{
                Image(systemName: "camera")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("_CAMERA")
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
