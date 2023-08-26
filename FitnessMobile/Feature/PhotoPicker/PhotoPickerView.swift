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
                    }
                    .padding()
                    .padding(.horizontal)
                }
                Spacer()
                /// BODY
                Group {
                    if let image = photoPickerManager.image {
                        image.resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            }
                    } else {
                        if photoPickerManager.isLoading {
                            ProgressView()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                        } else {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
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
                                VStack{
                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    Text("Take New Photo")
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
                                .frame(width: 30, height: 30)
                            Text("Take New Photo")
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color.Dark.tone90)
                        .cornerRadius(10)
                        .onTapGesture {
                            
                        }
                        
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear {
            photoPickerManager.fetchProfileImage()
        }
        .onChange(of: selectedItem) { _ in
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    let image = Image(uiImage: uiImage)
                    photoPickerManager.image = image
                } else {
                    photoPickerManager.image = nil
                }
            }
        }
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView()
    }
}
