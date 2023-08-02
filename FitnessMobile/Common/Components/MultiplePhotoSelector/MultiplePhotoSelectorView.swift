//
//  MultiplePhotoSelectorView.swift
//  HayEquipo
//
//  Created by David Gomez on 03/06/2023.
//

import SwiftUI
import PhotosUI

struct MultiplePhotoSelectorView: View {
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    var completion: (([Image]) -> Void)

    var body: some View {
        NavigationStack {
            ScrollView {
                PhotosPicker("Select images", selection: $selectedItems, matching: .images)
                
            }
            .toolbar {

            }
            .onChange(of: selectedItems) { _ in
                Task {
                    selectedImages.removeAll()

                    for item in selectedItems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                let image = Image(uiImage: uiImage)
                                selectedImages.append(image)
                                completion(selectedImages)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MultiplePhotoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplePhotoSelectorView(completion: { images in
            
        })
    }
}
