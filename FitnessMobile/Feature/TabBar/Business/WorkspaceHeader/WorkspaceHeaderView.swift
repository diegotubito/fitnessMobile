//
//  WorkspaceHeaderView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/11/2023.
//

import SwiftUI

struct WorkspaceHeaderView: View {
    @StateObject var viewmodel: WorkspaceHeaderViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                DefaultImageView(defaultIamgeViewModel: DefaultImageViewModel(workspace: viewmodel.workspace),
                                 size: 100,
                                 isEditable: false)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Default Workspace")
                        Image(systemName: "pencil")
                    }
                        Text(viewmodel.workspace.title)
                            .font(.title2)
                            .foregroundColor(Color.Neutral.tone80)
                        Text(viewmodel.workspace.subtitle)
                            .font(.title3)
                            .foregroundColor(Color.Neutral.tone80)
                }
                Spacer()
            }
            .padding()
            .background(Color.Neutral.tone100.opacity(0.5))
            .cornerRadius(10)
        }
    }
}

#Preview {
    let workspace = WorkspaceViewModelMock.getWorkspaces().first
    if let workspace = workspace {
        return  WorkspaceHeaderView(viewmodel: WorkspaceHeaderViewModel(workspace: workspace))
    } else {
        return Text("Loading...")
    }
    
}
