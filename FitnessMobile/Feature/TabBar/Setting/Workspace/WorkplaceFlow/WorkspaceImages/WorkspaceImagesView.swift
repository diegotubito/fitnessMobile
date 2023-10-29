//
//  WorkspaceImagesView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 27/10/2023.
//

import SwiftUI

struct WorkspaceImagesView: View {
    @StateObject var viewmodel: WorkspaceImagesViewModel
    
    @EnvironmentObject var coordinator: Coordinator
    
    struct Constants {
        static let deafultImageSize: CGFloat = 150
        static let deafultBackgroundImageSize: CGFloat = 300
    }
    
    var body: some View {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                GeometryReader { geometry in

                VStack {
                    ZStack {
                        DefaultBackgroundImageView(defaultBackgroundIamgeViewModel: DefaultBackgroundImageViewModel(workspace: viewmodel.workspace))
                            .onTapGesture {
                                coordinator.push(.workspaceEditBackgroundImageView(workspace: viewmodel.workspace))
                            }
                        
                        
                        DefaultImageView(defaultIamgeViewModel: DefaultImageViewModel(workspace: viewmodel.workspace), size: Constants.deafultImageSize)
                            .onTapGesture {
                                coordinator.push(.workspaceEditDefaultImageView(workspace: viewmodel.workspace))
                            }
                            .position(x: geometry.size.width - (Constants.deafultImageSize / 2), y: Constants.deafultImageSize * 1.3)
                    }
                    
                    ImageListView(viewmodel: ImageListViewModel(workspace: viewmodel.workspace))
                }
                .ignoresSafeArea()
            }
        }
    }
    
}

#Preview {
    let workspace = WorkspaceViewModelMock.getWorkspaces().first
    if let workspace = workspace {
        return WorkspaceImagesView(viewmodel: WorkspaceImagesViewModel(workspace: workspace))
    } else {
        return Text("Loading...")
    }
}
