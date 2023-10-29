//
//  DocumentCell.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 24/10/2023.
//

import SwiftUI

struct DocumentCell: View {
    @StateObject var viewmodel: DocumentCellViewModel
    
    var body: some View {
        VStack {
            Text("Document")
                .font(.subheadline)
                .foregroundColor(Color.Neutral.tone80)
            Image(uiImage: viewmodel.getImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .overlay {
                    if viewmodel.isLoading {
                        ProgressView()
                            .tint(.white)
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
