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
    
    func defaultImageView(proxy: GeometryProxy) -> some View {
        return VStack {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: proxy.size.width / 3, height: proxy.size.width / 3)
                    .background(Color.white)
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
                        Text("_EDIT_BUTTON")
                            .padding(3)
                            .padding(.horizontal, 16)
                            .font(.caption)
                            .foregroundColor(Color.Blue.truly)
                            .background(Color.Dark.tone20)
                            .cornerRadius(5)
                    }
                    .position(x: proxy.size.width / 6, y: proxy.size.width / 6)
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
            Image("image")
                .resizable()
                .frame(width: proxy.size.width, height: proxy.size.height / 4)
                .background(Color.gray)
            .overlay {
                if viewmodel.isLoading {
                    ProgressView()
                        .frame(width: proxy.size.width, height: proxy.size.height / 4)
                        .overlay {
                            Circle()
                                .stroke(Color.Dark.tone20, lineWidth: 2)
                        }
                        .shadow(radius: 5)
                } else {
                    Group {
                        Circle()
                            .stroke(Color.Dark.tone20, lineWidth: 2)
                        Text("_EDIT_BUTTON")
                            .padding(3)
                            .padding(.horizontal, 16)
                            .font(.caption)
                            .foregroundColor(Color.Blue.truly)
                            .background(Color.Dark.tone20)
                            .cornerRadius(5)
                    }
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 8)
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
            defaultImageView(proxy: proxy)
                .background {
                    defaultBackgroundImageView(proxy: proxy)
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
