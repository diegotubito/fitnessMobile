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
       @State private var selectedImage: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                /// HEADER
                Group {
                    HStack {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                dismiss()
                            }
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                photoPickerManager.uploadImage()
                            }
                        
                    }
                    .padding()
                    .padding(.horizontal)
                }
                Spacer()
                /// BODY
                Group {
                    if let image = photoPickerManager.imageData?.asImage {
                        image.resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            }
                    }
                    else if !photoPickerManager.isLoading {
                        
                        Image(systemName: "photo.circle").resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            }
                    }
                }
                Spacer()
                
                /// FOOTER
                Group {
                    HStack {
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
                .padding()
                .frame(height: 30)
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
        .onChange(of: selectedImage, perform: { value in
            if let image = selectedImage,
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
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
        })
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView()
    }
}
