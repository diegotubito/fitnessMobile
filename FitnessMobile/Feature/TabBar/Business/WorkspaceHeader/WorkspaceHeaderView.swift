//
//  WorkspaceHeaderView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/11/2023.
//

import SwiftUI

struct WorkspaceHeaderView: View {
    @StateObject var viewmodel: WorkspaceHeaderViewModel = WorkspaceHeaderViewModel()
    @EnvironmentObject var businessCoordinator: BusinessCoordinator
  
    var size: CGFloat
    var isEditable: Bool
    var onPencilDidTapped: () -> Void
    var onEditDidTapped: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(uiImage: UIImage(data: viewmodel.imageData ?? Data()) ?? UIImage(systemName: "person.crop.circle.fill")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay {
                        if viewmodel.isLoading {
                            ProgressView()
                                .frame(width: 100, height: 100)
                                .overlay {
                                    Circle()
                                        .stroke(Color.Dark.tone20, lineWidth: 2)
                                }
                                .shadow(radius: 5)
                                .tint(.white)
                        } else {
                            Circle()
                                .stroke(Color.Dark.tone20, lineWidth: 2)
                            if isEditable {
                                Text("_EDIT_BUTTON")
                                    .padding(3)
                                    .padding(.horizontal, 2)
                                    .font(.caption)
                                    .foregroundColor(Color.Blue.truly)
                                    .background(Color.Dark.tone20)
                                    .cornerRadius(5)
                                    .offset(CGSize(width: 0, height: 100 / 2))
                                    .shadow(radius: 5)
                                    .onTapGesture {
                                        onEditDidTapped()
                                    }
                            }
                        }
                    }
                    .shadow(radius: 10)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Default Workspace")
                        Image(systemName: "pencil")
                    }
                    .foregroundColor(Color.Neutral.tone80)
                    .onTapGesture {
                        onPencilDidTapped()
                    }
                    Text(viewmodel.defaultWorkspace?.title ?? "")
                        .font(.title2)
                        .foregroundColor(Color.Neutral.tone80)
                    Text(viewmodel.defaultWorkspace?.subtitle ?? "")
                        .font(.title3)
                        .foregroundColor(Color.Neutral.tone80)
                }
                Spacer()
            }
            .padding()
            .background(Color.Neutral.tone100.opacity(0.5))
            .cornerRadius(10)
        }
        .onAppear {
            viewmodel.loadDefaultWorkspace()
        }
    }
}

#Preview {
    WorkspaceHeaderView(size: 100, isEditable: true, onPencilDidTapped: {
        
    }, onEditDidTapped: {
        
    })
}
