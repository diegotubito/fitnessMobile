//
//  BackgroundImageView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 29/10/2023.
//

import SwiftUI

struct DefaultBackgroundImageView: View {
    @StateObject var defaultBackgroundIamgeViewModel: DefaultBackgroundImageViewModel
    
    var body: some View {
        GeometryReader { proxy in
            defaultBackgroundIamgeViewModel.getImageView()
                .resizable()
                .scaledToFill()
                .onAppear {
                    defaultBackgroundIamgeViewModel.fetchBackgroundImage()
                }
                .overlay {
                    if defaultBackgroundIamgeViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("_EDIT_BUTTON_DEFAULT_BACKGROUND_IMAGE")
                            .padding(3)
                            .padding(.horizontal, 16)
                            .font(.caption)
                            .foregroundColor(Color.Blue.truly)
                            .background(Color.Dark.tone20)
                            .cornerRadius(5)
                            .shadow(radius: 10)
                            .position(x: proxy.size.width - 70, y: proxy.size.height - 16)
                    }
                }
        }
    }
}

#Preview {
    let workspace = WorkspaceViewModelMock.getWorkspaces().first
    if let workspace = workspace {
        return DefaultBackgroundImageView(defaultBackgroundIamgeViewModel: DefaultBackgroundImageViewModel(workspace: workspace))
    } else {
        return Text("Loading...")
    }
}
