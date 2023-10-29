//
//  ImageListCell.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 29/10/2023.
//

import SwiftUI

struct ImageListCell: View {
    @StateObject var viewmodel: ImageListCellViewModel
    
    var body: some View {
        VStack {
            Image(uiImage: viewmodel.getImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .overlay {
                    if viewmodel.isLoading {
                        ProgressView()
                    }
                }
            Text(viewmodel.getImageSize())
                .font(.caption)
                .foregroundColor(Color.Neutral.tone80)
        }
        .onAppear {
            viewmodel.loadDocumentImageFromApi()
        }
    }
}

#Preview {
    ImageListCell(viewmodel: ImageListCellViewModel(image: ImageModel(_id: "", creator: "", highResImage: nil, thumbnailImage: nil)))
}
