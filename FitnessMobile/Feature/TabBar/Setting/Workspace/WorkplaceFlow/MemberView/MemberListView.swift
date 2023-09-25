//
//  MemberList.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 17/09/2023.
//

import SwiftUI

struct MemberListView: View {
    @ObservedObject var viewmodel: MemberViewModel
    
    var trushTapped: ((WorkspaceModel.WorkspaceMember) -> Void)?
    
    var body: some View {
        ForEach(viewmodel.members, id: \.self) { member in
            VStack {
                HStack {
                    /*
                     if let image = member.image, let uiimage = UIImage(data: image) {
                     Image(uiImage: uiimage)
                     .resizable()
                     .frame(width: 20, height: 20)
                     .clipShape(Circle())
                     } else {
                     Image(systemName: "person")
                     .resizable()
                     .frame(width: 20, height: 20)
                     .clipShape(Circle())
                     }
                     */
                    Text("\(member.user.username) (\(member.user.firstName) \(member.user.lastName))")
                        .font(.callout)
                    Text(viewmodel.getRole(role: member.role))
                    Spacer()
                    Image(systemName: "trash")
                        .foregroundColor(Color.Red.truly)
                        .onTapGesture {
                            
                            self.trushTapped?(member)
                        }
                }
                .foregroundColor(Color.Neutral.tone90)
                Divider()
            }
        }
        
    }
}
