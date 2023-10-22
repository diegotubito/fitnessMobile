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
            case removeDocument
        }
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
                
                Text("You have no documents uploaded.")
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
            if item.sheet == .uploadNewDocument {
                UploadFileSheetView { image in
                    selectedSheet = .none
                }
                .presentationDetents([.medium, .fraction(0.30)])
                .presentationBackground(Color.Blue.midnight)
            } else if item.sheet == .removeDocument {
                DeleteSheetView(title: "_REMOVE_INVITATION_TITLE", subtitle: "_REMOVE_INVITATION_SUBTITLE", onTapped: { optionTapped in
                    if optionTapped == .accept {
                        // handle accept button here
                    }
                    selectedSheet = .none
                })
                    .presentationDetents([.medium, .fraction(0.30)])
                    .presentationBackground(Color.Blue.midnight)
            }
        })
    }
}
