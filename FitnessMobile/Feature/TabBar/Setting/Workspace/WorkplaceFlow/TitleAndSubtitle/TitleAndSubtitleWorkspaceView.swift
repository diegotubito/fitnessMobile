//
//  CreateWorkspace.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/09/2023.
//

import SwiftUI

struct TitleAndSubtitleWorkspaceView: View {
    @StateObject var viewmodel: WorkspaceTitleAndSubtitleViewModel
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
                        CustomTextField(customTextFieldManager: viewmodel.titleTextFieldManager, title: "_TITLE_SUBTITLE_WORKSPACE_VIEW_TITLE", placeholder: "", footer: "") { newString in
                            viewmodel.validate()
                        } onDidBegin: { didBegin in
                            if didBegin {
                                viewmodel.titleTextFieldManager.shouldShowError = false
                            } else {
                                focus = .subtitle
                                if !viewmodel.isTitleValid {
                                    viewmodel.titleTextFieldManager.showError(message: "_TITLE_SUBTITLE_WORKSPACE_VIEW_ERROR_TITLE")
                                }
                            }
                        }
                        .focused($focus, equals: .title)
                        
                        CustomTextField(customTextFieldManager: viewmodel.subtitleTextFieldManager, title: "_TITLE_SUBTITLE_WORKSPACE_VIEW_SUBTITLE", placeholder: "", footer: "") { newString in
                            viewmodel.validate()
                        } onDidBegin: { didBegin in
                            if didBegin {
                                viewmodel.subtitleTextFieldManager.shouldShowError = false
                            } else {
                                if !viewmodel.isSubtitleValid {
                                    viewmodel.subtitleTextFieldManager.showError(message: "_TITLE_SUBTITLE_WORKSPACE_VIEW_ERROR_SUBTITLE")
                                }
                            }
                        }
                        .focused($focus, equals: .subtitle)

                    }
                }
                
                Spacer()
                
                if !viewmodel.isEditing {
                    BasicButton(title: "_TITLE_SUBTITLE_WORKSPACE_VIEW_BUTTON_TITLE_CREATE", style: .primary, isEnabled: .constant(!viewmodel.disabledButton)) {
                        viewmodel.createWorkspace()
                    }
                } else {
                    BasicButton(title: "_TITLE_SUBTITLE_WORKSPACE_VIEW_BUTTON_TITLE_UPDATE", style: .primary, isEnabled: .constant(!viewmodel.disabledButton)) {
                        viewmodel.updateWorkspace()
                    }
                }
            }
            .onReceive(viewmodel.$onUpdateSuccess, perform: { updated in
                if updated {
                    coordinator.path.removeLast(2)
                }
            })
            .onReceive(viewmodel.$onCreateSuccess, perform: { created in
                if created {
                    coordinator.path.removeLast(1)
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

struct TitleAndSubtitleWorkspaceView_Previews: PreviewProvider {
    static var previews: some View {
        TitleAndSubtitleWorkspaceView(viewmodel: WorkspaceTitleAndSubtitleViewModel(workspace: nil))
    }
}
