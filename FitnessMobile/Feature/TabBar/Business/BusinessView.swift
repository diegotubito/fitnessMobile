//
//  BusinessView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/11/2023.
//

import SwiftUI

struct BusinessView: View {
    @StateObject var viewmodel = BusinessViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.black, Color.Blue.midnight], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    if let defaultWorkspace = viewmodel.defaultWorkspace {
                        VStack {
                            WorkspaceHeaderView(viewmodel: WorkspaceHeaderViewModel(workspace: defaultWorkspace))
                        }
                    }
                    Spacer()
                }
                
            }
        }
        .onAppear {
            viewmodel.getWorkspacesFromLocal()
            viewmodel.getDefaultWorkspace()
        }
    }
}

#Preview {
    BusinessView()
}
