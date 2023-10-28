//
//  EditBackgroundImageView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 28/10/2023.
//

import SwiftUI
import PhotosUI

struct EditBackgroundImageView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewmodel: EditBackgroundImageViewModel
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
                    PhotoView(geometry: geometry)
                        .padding(.bottom)
                    Spacer()
                    Buttons()
                }
            }
            .navigationBarItems(trailing: Button("Save") {
                viewmodel.uploadImage()
            })
        }
        
        .onAppear {
            viewmodel.fetchBackgroundImage()
        }
        .onChange(of: selectedItem) { _ in
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data),
                   let compressedData = image.jpegData(compressionQuality: 0.1) {
                    print("Original Image Sized: \(data.count)")
                    print("Compressed Image Sized: \(compressedData.count)")
                    viewmodel.imageData = compressedData
                } else {
                    viewmodel.imageData = nil
                }
            }
        }
        .onChange(of: imageFromCamera, perform: { value in
            if let image = imageFromCamera,
               let compressedData = image.jpegData(compressionQuality: 0.1) {
                print("Compressed Image Sized: \(compressedData.count)")
                viewmodel.imageData = compressedData
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
                .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.6)
                .clipShape(Rectangle())
                .overlay {
                    Rectangle()
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

struct EditBackgroundImageView_Previews: PreviewProvider {
    static var previews: some View {
        if let workspace = WorkspaceViewModelMock.getWorkspaces().first {
            EditBackgroundImageView(viewmodel: EditBackgroundImageViewModel(workspace: workspace))
        } else {
            Text("loading")
        }
    }
}
