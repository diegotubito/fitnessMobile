//
//  ProfileImageView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 29/10/2023.
//

import SwiftUI

struct DefaultImageView: View {
    @StateObject var defaultIamgeViewModel: DefaultImageViewModel
    
    var size: CGFloat
    
    var body: some View {
        VStack {
            defaultIamgeViewModel.getImageView()
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay {
                    if defaultIamgeViewModel.isLoading {
                        ProgressView()
                            .frame(width: size, height: size)
                            .overlay {
                                Circle()
                                    .stroke(Color.Dark.tone20, lineWidth: 2)
                            }
                            .shadow(radius: 5)
                            .tint(.white)
                    } else {
                        Circle()
                            .stroke(Color.Dark.tone20, lineWidth: 2)
                        Text("_EDIT_BUTTON")
                            .padding(3)
                            .padding(.horizontal, 2)
                            .font(.caption)
                            .foregroundColor(Color.Blue.truly)
                            .background(Color.Dark.tone20)
                            .cornerRadius(5)
                            .offset(CGSize(width: 0, height: size / 2))
                            .shadow(radius: 5)
                    }
                }
                .shadow(radius: 10)
        }
        .onAppear {
            defaultIamgeViewModel.fetchDefaultImage()
        }
    }
}

#Preview {
    let workspace = WorkspaceViewModelMock.getWorkspaces().first
    if let workspace = workspace {
        return DefaultImageView(defaultIamgeViewModel: DefaultImageViewModel(workspace: workspace), size: 100)
    } else {
        return Text("Loading...")
    }
    
}

