//
//  WorkspaceImagesView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 27/10/2023.
//

import SwiftUI

struct WorkspaceImagesView: View {
    @StateObject var viewmodel: WorkspaceImagesViewModel
    @StateObject var defaultBackgroundIamgeViewModel: EditBackgroundImageViewModel
    
    @EnvironmentObject var coordinator: Coordinator
    
    struct Constants {
        static let deafultImageSize: CGFloat = 150
        static let deafultBackgroundImageSize: CGFloat = 300
    }
    
    func defaultBackgroundImageView() -> some View {
        return  GeometryReader { proxy in
            ZStack {
                defaultBackgroundIamgeViewModel.getImageView()
                    .resizable()
                    .scaledToFill()
                    .onAppear {
                        defaultBackgroundIamgeViewModel.fetchBackgroundImage()
                    }
                Text("_EDIT_BUTTON_DEFAULT_BACKGROUND_IMAGE")
                    .padding(3)
                    .padding(.horizontal, 16)
                    .font(.caption)
                    .foregroundColor(Color.Blue.truly)
                    .background(Color.Dark.tone20)
                    .cornerRadius(5)
                    .shadow(radius: 10)
                    .onTapGesture {
                        coordinator.push(.workspaceEditBackgroundImageView(workspace: viewmodel.workspace))
                    }
                    .position(x: proxy.size.width - 70, y: proxy.size.height - 16)
            }
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                ZStack {
                    defaultBackgroundImageView()
                        
                    DefaultImageView(defaultIamgeViewModel: EditDefaultImageViewModel(workspace: viewmodel.workspace))
                        .onTapGesture {
                            coordinator.push(.workspaceEditDefaultImageView(workspace: viewmodel.workspace))
                        }
                }
                
                ImageListView(viewmodel: ImageListViewModel(workspace: viewmodel.workspace))
            }
        }
    }
    
}

#Preview {
    let workspace = WorkspaceViewModelMock.getWorkspaces().first
    if let workspace = workspace {
        return WorkspaceImagesView(viewmodel: WorkspaceImagesViewModel(workspace: workspace), defaultBackgroundIamgeViewModel: EditBackgroundImageViewModel(workspace: workspace))
    } else {
        return Text("Loading...")
    }
}
