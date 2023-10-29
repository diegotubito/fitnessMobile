//
//  WorkspaceImagesView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 27/10/2023.
//

import SwiftUI

struct WorkspaceImagesView: View {
    @StateObject var viewmodel: WorkspaceImagesViewModel
    @StateObject var defaultIamgeViewModel: EditDefaultImageViewModel
    @StateObject var defaultBackgroundIamgeViewModel: EditBackgroundImageViewModel
    
    @EnvironmentObject var coordinator: Coordinator
    
    struct Constants {
        static let deafultImageSize: CGFloat = 150
        static let deafultBackgroundImageSize: CGFloat = 300
    }
    
    func defaultImageView(proxy: GeometryProxy) -> some View {
        return VStack {
            HStack {
                defaultIamgeViewModel.getImageView()
                    .resizable()
                    .frame(width: proxy.size.width / 3, height: proxy.size.width / 3)
                    .clipShape(Circle())
                    .onAppear {
                        defaultIamgeViewModel.fetchDefaultImage()
                    }
                Spacer()
            }
            .overlay {
                if viewmodel.isLoading {
                    ProgressView()
                        .frame(width: proxy.size.width / 3, height: proxy.size.width / 3)
                        .overlay {
                            Circle()
                                .stroke(Color.Dark.tone20, lineWidth: 2)
                        }
                        .shadow(radius: 5)
                } else {
                    Group {
                        Circle()
                            .stroke(Color.Dark.tone20, lineWidth: 2)
                            .position(x: proxy.size.width / 6, y: proxy.size.width / 6)
                        Text("_EDIT_BUTTON")
                            .padding(3)
                            .padding(.horizontal, 16)
                            .font(.caption)
                            .foregroundColor(Color.Blue.truly)
                            .background(Color.Dark.tone20)
                            .cornerRadius(5)
                            .position(x: proxy.size.width / 6, y: proxy.size.width / 3.2)
                    }
                    .shadow(radius: 10)
                    .onTapGesture {
                        coordinator.push(.workspaceEditDefaultImageView(workspace: viewmodel.workspace))
                    }
                }
            }
        }
    }
    
    func defaultBackgroundImageView(proxy: GeometryProxy) -> some View {
        return VStack {
            defaultBackgroundIamgeViewModel.getImageView()
                .resizable()
                .scaledToFill()
                .onAppear {
                    defaultBackgroundIamgeViewModel.fetchBackgroundImage()
                }
            .overlay {
                if viewmodel.isLoading {
                    ProgressView()
                } else {
                    Text("_EDIT_BUTTON")
                        .padding(3)
                        .padding(.horizontal, 16)
                        .font(.caption)
                        .foregroundColor(Color.Blue.truly)
                        .background(Color.Dark.tone20)
                        .cornerRadius(5)
                        .position(x: proxy.size.width - 50, y: proxy.size.height / 3.2)
                        .shadow(radius: 10)
                        .onTapGesture {
                            coordinator.push(.workspaceEditBackgroundImageView(workspace: viewmodel.workspace))
                        }
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    ZStack {
                        defaultBackgroundImageView(proxy: proxy)
                            .frame(width: proxy.size.width, height: proxy.size.height / 4)
                            .ignoresSafeArea()
                        defaultImageView(proxy: proxy)
                    }
                    
                    ImageListView(viewmodel: ImageListViewModel(workspace: viewmodel.workspace))
                }
            }
        }
    }
        
}

#Preview {
    let workspace = WorkspaceViewModelMock.getWorkspaces().first
    if let workspace = workspace {
        return WorkspaceImagesView(viewmodel: WorkspaceImagesViewModel(workspace: workspace), defaultIamgeViewModel: EditDefaultImageViewModel(workspace: workspace), defaultBackgroundIamgeViewModel: EditBackgroundImageViewModel(workspace: workspace))
    } else {
        return Text("Loading...")
    }
}
