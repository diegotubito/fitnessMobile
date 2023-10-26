//
//  ShareDocumentView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 22/10/2023.
//

import SwiftUI

struct ShareDocumentView: View {
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
    
    @StateObject var viewmodel: ShareDocumentViewModel
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.Blue.midnight, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("_WORKSPACE_SHARE_DOCUMENT_TITLE")
                    .font(.title)
                    .foregroundColor(Color.Neutral.tone80)
                    .padding(.bottom)
                Text("_WORKSPACE_SHARE_DOCUMENT_SUBTITLE")
                    .font(.subheadline)
                    .foregroundColor(Color.Neutral.tone80)
                    .padding(.bottom)
                
                ScrollView {
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        ForEach(viewmodel.workspace.documentImages, id: \.self) { document in
                            DocumentCell(viewmodel: DocumentCellViewModel(document: document))
                                .onTapGesture {
                                    selectedSheet = Sheet(sheet: .removeDocument(document: document))
                                }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("_WORKSPACE_SHARE_DOCUMENT_NAV_TITLE")
        .toolbar(content: {

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("_NEW_WORSPACE_BUTTON_TITLE") {
                    selectedSheet = Sheet(sheet: .uploadNewDocument)
                }.disabled(false)
            }
            
        })
        .sheet(item: $selectedSheet, onDismiss: {
            
        }, content: { item in
            switch item.sheet {
            case .uploadNewDocument:
                UploadFileSheetView { imageData, size, dimensions in
                    selectedSheet = .none
                    if let imageData = imageData, let size = size, let dimensions = dimensions {
                        viewmodel.uploadDocumentImage(data: imageData)
                    }
                }
                .presentationDetents([.medium, .fraction(0.30)])
                .presentationBackground(Color.Blue.midnight)
            case .removeDocument(document: let document):
                DeleteSheetView(title: "_REMOVE_WORKSPACE_DOCUMENT_TITLE", subtitle: "_REMOVE_WORKSPACE_DOCUMENT_SUBTITLE", onTapped: { optionTapped in
                    if optionTapped == .accept {
                        viewmodel.removeDocumentImage(documentId: document._id)
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
