//
//  DefaultWorkspaceSelectorView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 15/11/2023.
//

import SwiftUI

struct DefaultWorkspaceSelectorView: View {
    @StateObject var splashViewModel: SplashViewModel = SplashViewModel()
    @StateObject var viewModel: DefaultWorkspaceSelectorViewModel = DefaultWorkspaceSelectorViewModel()
    @ObservedObject var workspaceHeaderViewModel: WorkspaceHeaderViewModel = WorkspaceHeaderViewModel()

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, Color.Blue.midnight], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text("Select your default workspace")
                    .foregroundStyle(Color.Neutral.tone80)
                
                SingleSelectorView(singleSelectorManager: viewModel.singleSelectorManager) { selectedWorkspaceId in
                    if let selectedWorkspaceId = selectedWorkspaceId {
                        viewModel.setDefaultWorkspace(_id: selectedWorkspaceId)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .onChange(of: splashViewModel.workspaces, { oldValue, newValue in
            if !newValue.isEmpty {
                viewModel.setupOptions(newValue)
            }
        })
        .onAppear {
            splashViewModel.loadWorkspaces()
        }
    }
    
}

/*
#Preview {
    DefaultWorkspaceSelectorView(splashViewModel: BusinessViewModel(), defaultWorkspace: WorkspaceModel(_id: <#T##String#>, title: <#T##String#>, subtitle: <#T##String#>, isEnabled: <#T##Bool#>, owner: <#T##String#>, createdAt: <#T##String#>, updatedAt: <#T##String#>, members: <#T##[WorkspaceModel.WorkspaceMember]#>, location: <#T##WorkspaceModel.Location?#>, locationVerificationStatus: <#T##WorkspaceModel.Status?#>, documentImages: <#T##[ImageModel]#>, defaultImage: <#T##ImageModel?#>, defaultBackgroundImage: <#T##ImageModel?#>, images: <#T##[ImageModel]?#>))
}
*/
