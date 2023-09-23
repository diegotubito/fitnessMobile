//
//  MemberList.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 17/09/2023.
//

import SwiftUI

struct MemberListView: View {
    @StateObject var viewmodel: MemberViewModel
    @State var shouldPresentSheet = false
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            ForEach(viewmodel.members, id: \.self) { member in
                HStack {
                    if let image = member.image, let uiimage = UIImage(data: image) {
                        Image(uiImage: uiimage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person")
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                    
                    VStack {
                        Text("\(member.user.username) (\(member.user.firstName) \(member.user.lastName))")
                        Text("\(member.user.email)")
                    }
                    Spacer()
                    Image(systemName: "trash")
                        .foregroundColor(Color.Red.truly)
                        .onTapGesture {
                            shouldPresentSheet = true
                            viewmodel.selectedMember = member
                        }
                }
                .onAppear {
                    viewmodel.fetchProfileImage(member: member)
                }
            }
        }
        .sheet(isPresented: $shouldPresentSheet, content: {
            if shouldPresentSheet {
                VStack {
                    Text("_REMOVE_MEMBER_TITLE")
                        .padding()
                        .font(.title)
                    Text(viewmodel.subtitle)
                        .font(.subheadline)
                    Spacer()
                    HStack {
                        BasicButton(title: "_REMOVE_MEMBER_CANCEL_BUTTON", style: .secondary, isEnabled: .constant(true)) {
                            self.shouldPresentSheet = false
                        }
                        BasicButton(title: "_REMOVE_MEMBER_REMOVE_BUTTON", style: .destructive, isEnabled: .constant(true)) {
                            self.viewmodel.deleteMember()
                            self.shouldPresentSheet = false
                        }
                    }
                }
                .padding(32)
                .presentationDetents([.medium, .fraction(0.35)])
                .presentationBackground(Color.Blue.midnight)
            }
            
        })
        .onReceive(viewmodel.$onDeletedMember) { isDeleted in
            if isDeleted {
                coordinator.path.removeLast()
            }
        }
    }
}
