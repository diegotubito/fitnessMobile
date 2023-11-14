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
                    VStack {
                        if let workspace = viewmodel.defaultWorkspace {
                            WorkspaceHeaderView(viewmodel: WorkspaceHeaderViewModel(workspace: workspace))
                        }
                    }
                    Spacer()
                }
                
            }
        }
        .onAppear {
            viewmodel.loadWorkspace()
        }
    }
}

#Preview {
    BusinessView()
}
