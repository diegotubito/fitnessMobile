//
//  MemberList.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 17/09/2023.
//

import SwiftUI

struct MemberListView: View {
    @StateObject var viewmodel: MemberViewModel
    
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
                            
                        }
                }
                .onAppear {
                    viewmodel.fetchProfileImage(member: member)
                }
            }
        }
    }
}

struct MemberList_Previews: PreviewProvider {
    static var previews: some View {
        MemberListView(viewmodel: MemberViewModel(members: [WorkspaceModel.WorkspaceMember(user: User(_id: "",
                                                                                                      username: "UserName",
                                                                                                      email: "mi email",
                                                                                                      firstName: "David Diego",
                                                                                                      lastName: "Gomez",
                                                                                                      isEnabled: true,
                                                                                                      phone: nil,
                                                                                                      emailVerified: true,
                                                                                                      createdAt: "",
                                                                                                      updatedAt: "",
                                                                                                      twoFactorEnabled: true,
                                                                                                      twoFactorSecret: nil,
                                                                                                      profileImage: nil), role: "ADMIN_ROLE")]))
    }
}
