//
//  CreateWorkspace.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/09/2023.
//

import SwiftUI

struct WorkspaceView: View {
    @StateObject var viewmodel: WorkspaceViewModel
    @EnvironmentObject var coordinator: Coordinator
    
    @FocusState var focus: Focus?
    
    enum Focus {
        case title
        case subtitle
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.Blue.midnight, Color.Dark.tone120, .black], startPoint: .leading, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack {
                        CustomTextField(customTextFieldManager: viewmodel.titleTextFieldManager, title: "Title", placeholder: "", footer: "") { newString in
                            viewmodel.validate()
                        } onDidBegin: { didBegin in
                            if didBegin {
                                viewmodel.titleTextFieldManager.shouldShowError = false
                            } else {
                                focus = .subtitle
                                if !viewmodel.isTitleValid {
                                    viewmodel.titleTextFieldManager.showError(message: "Title is badly format or empty field")
                                }
                            }
                        }
                        .focused($focus, equals: .title)
                        
                        CustomTextField(customTextFieldManager: viewmodel.subtitleTextFieldManager, title: "Subtitle", placeholder: "", footer: "") { newString in
                            viewmodel.validate()
                        } onDidBegin: { didBegin in
                            if didBegin {
                                viewmodel.subtitleTextFieldManager.shouldShowError = false
                            } else {
                                if !viewmodel.isSubtitleValid {
                                    viewmodel.subtitleTextFieldManager.showError(message: "Subtitle is badly format or empty field")
                                }
                            }
                        }
                        .focused($focus, equals: .subtitle)

                    }
                }
                
                Spacer()
                
                if !viewmodel.isEditing {
                    BasicButton(title: "Create", style: .primary, isEnabled: .constant(!viewmodel.disabledButton)) {
                        viewmodel.createWorkspace()
                    }
                } else {
                    BasicButton(title: "Update", style: .primary, isEnabled: .constant(!viewmodel.disabledButton)) {
                        viewmodel.updateWorkspace()
                    }
                }
            }
            .onReceive(viewmodel.$onUpdateSuccess, perform: { updated in
                if updated {
                    coordinator.path.removeLast()
                }
            })
            .onReceive(viewmodel.$onCreateSuccess, perform: { created in
                if created {
                    coordinator.path.removeLast()
                }
            })
            .padding()
        }
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
        .onAppear {
            viewmodel.setupInitValues()
            focus = .title
            viewmodel.validate()
        }
    }
}

struct CreateWorkspaceView_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceView(viewmodel: WorkspaceViewModel(workspace: nil))
    }
}
