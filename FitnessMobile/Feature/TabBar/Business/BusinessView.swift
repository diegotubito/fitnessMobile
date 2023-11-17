//
//  BusinessView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/11/2023.
//

import SwiftUI

class BusinessCoordinator: ObservableObject {
    @Published var path: [Screen] = []
    
    enum Screen: Hashable {
        var id: UUID {
            return UUID()
        }
        case defaultWorkspaceSelector
    }
    
    func push(_ screen: Screen) {
        path.append(screen)
    }

    func push(_ screens: [Screen]) {
        path.append(contentsOf: screens)
    }

    func pop() {
        path.removeLast()
    }
    
    @ViewBuilder
    func getPage(_ screen: Screen) -> some View {
    }
}

struct BusinessView: View {
    @StateObject var viewmodel = BusinessViewModel()
    @StateObject var businessCoordinator = BusinessCoordinator()
    
    var body: some View {
        NavigationStack(path: $businessCoordinator.path) {
            ZStack {
                LinearGradient(colors: [.black, Color.Blue.midnight], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    WorkspaceHeaderView(size: 100, isEditable: false, onPencilDidTapped: {
                        businessCoordinator.push(.defaultWorkspaceSelector)
                    }, onEditDidTapped: {
                        
                    })
                    Spacer()
                }
            }
            .navigationDestination(for: BusinessCoordinator.Screen.self) { screen in
                switch screen {
                case .defaultWorkspaceSelector:
                    DefaultWorkspaceSelectorView()
                }
            }
        }

        .environmentObject(businessCoordinator)
    }
}

#Preview {
    BusinessView()
}
