//
//  PhotoPickerView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 26/08/2023.
//

import SwiftUI

struct PhotoPickerView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var photoPickerManager = PhotoPickerManager()
 
    var body: some View {
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
            
            /// BODY
            Group {
                if let image = photoPickerManager.image {
                    image.resizable()
                        .frame(width: 100, height: 100)
                } else {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            }
            Spacer()
        }
        .onAppear {
            photoPickerManager.fetchProfileImage()
        }
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView()
    }
}
