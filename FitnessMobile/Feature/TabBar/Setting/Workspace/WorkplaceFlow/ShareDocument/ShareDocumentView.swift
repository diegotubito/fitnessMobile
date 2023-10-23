//
//  ShareDocumentView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 22/10/2023.
//

import SwiftUI

struct ShareDocumentView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var photoPickerManager = PhotoPickerManager()
    
    @State private var selectedSheet: Sheet? = nil
    
    struct Sheet: Identifiable {
        let id: UUID? = UUID()
        let sheet: SheetStyle
        
        enum SheetStyle {
            case uploadNewDocument
            case removeDocument(url: String)
        }
    }
    
    var workspace: WorkspaceModel
    
    init(workspace: WorkspaceModel) {
        self.workspace = workspace
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.Blue.midnight, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Sharing documents it's crucial to approve your address.")
                    .font(.title)
                    .padding(.bottom)
                Text("You can upload any kind of document that belongs to you and the address match with the one you declared.")
                    .font(.subheadline)
                    .padding(.bottom)
                
                ScrollView {
                    ForEach(Array(workspace.locationVerifiedDocuments.enumerated()), id: \.offset) { index, url in
                        Text("Document \(index + 1)")
                            .onTapGesture {
                                selectedSheet = Sheet(sheet: .removeDocument(url: url))
                            }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Share Documents")
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
                UploadFileSheetView { imageData in
                    selectedSheet = .none
                    if let imageData = imageData {
                        photoPickerManager.uploadDocumentImage(workspaceId: workspace._id, data: imageData)
                    }
                }
                .presentationDetents([.medium, .fraction(0.30)])
                .presentationBackground(Color.Blue.midnight)
            case .removeDocument(url: let url):
                DeleteSheetView(title: "_REMOVE_WORKSPACE_DOCUMENT_TITLE", subtitle: "_REMOVE_WORKSPACE_DOCUMENT_SUBTITLE", onTapped: { optionTapped in
                    if optionTapped == .accept {
                        Task {
                            await photoPickerManager.removeDocuemtnUrlToWorskspace(workspaceId: workspace._id, url: url)
                        }
                    }
                    selectedSheet = .none
                })
                    .presentationDetents([.medium, .fraction(0.30)])
                    .presentationBackground(Color.Blue.midnight)
            }
        })
        .onReceive(photoPickerManager.$imageUploaded) { value in
            if value {
                coordinator.path.removeLast()
            }
        }
        .onReceive(photoPickerManager.$urlRemoved) { value in
            if value {
                coordinator.path.removeLast()
            }
        }
    }
}
