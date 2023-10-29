//
//  ImageListView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 29/10/2023.
//

import SwiftUI

struct ImageListView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    @State private var selectedSheet: Sheet? = nil
    
    struct Sheet: Identifiable {
        let id: UUID? = UUID()
        let sheet: SheetStyle
        
        enum SheetStyle {
            case uploadNewDocument
            case removeDocument(document: ImageModel)
        }
    }
    
    @StateObject var viewmodel: ImageListViewModel
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.Blue.midnight, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("_WORKSPACE_IMAGE_LIST_SUBTITLE")
                    .font(.subheadline)
                    .foregroundColor(Color.Neutral.tone80)
                    .padding(.bottom)
                
                ScrollView {
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        ForEach(viewmodel.workspace.images ?? [], id: \.self) { image in
                            ImageListCell(viewmodel: ImageListCellViewModel(image: image))
                                .onTapGesture {
                                    selectedSheet = Sheet(sheet: .removeDocument(document: image))
                                }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("_WORKSPACE_IMAGE_LIST_NAV_TITLE")
        .navigationBarItems(trailing: ColoredButton(action: {
            selectedSheet = Sheet(sheet: .uploadNewDocument)
        }, title: "_WORKSPACE_UPLOAD_IMAGE_TITLE"))
        .sheet(item: $selectedSheet, onDismiss: {
            
        }, content: { item in
            switch item.sheet {
            case .uploadNewDocument:
                UploadFileSheetView { imageData, size, dimensions in
                    selectedSheet = .none
                    if let imageData = imageData, let size = size, let dimensions = dimensions {
                        viewmodel.uploadImage(data: imageData)
                    }
                }
                .presentationDetents([.medium, .fraction(0.30)])
                .presentationBackground(Color.Blue.midnight)
            case .removeDocument(document: let document):
                DeleteSheetView(title: "_REMOVE_WORKSPACE_IMAGE_TITLE", subtitle: "_REMOVE_WORKSPACE_IMAGE_SUBTITLE", onTapped: { optionTapped in
                    if optionTapped == .accept {
                        viewmodel.removeImage(documentId: document._id)
                    }
                    selectedSheet = .none
                })
                    .presentationDetents([.medium, .fraction(0.30)])
                    .presentationBackground(Color.Blue.midnight)
            }
        })
        .onReceive(viewmodel.$onUploadedImage) { value in
            if value {
                viewmodel.loadWorkspacesById()
            }
        }
        .onReceive(viewmodel.$onRemovedImage) { value in
            if value {
                viewmodel.loadWorkspacesById()
            }
        }
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
    }
}

#Preview {
    if let workspace = WorkspaceViewModelMock.getWorkspaces().first {
        ImageListView(viewmodel: ImageListViewModel(workspace: workspace))
    } else {
        Text("loading")
    }
}
