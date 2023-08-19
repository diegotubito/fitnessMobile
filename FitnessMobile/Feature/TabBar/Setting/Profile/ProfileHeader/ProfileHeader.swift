//
//  ProfileHeader.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 08/08/2023.
//

import SwiftUI

struct ProfileHeader: View {
    @State var shouldUpdateView = true
    
    var body: some View {
        VStack {
            if shouldUpdateView {
                HStack(spacing: 16) {
                    Image("profile_diego")
                        .resizable()
                        .frame(width: 85, height: 85)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(radius: 5)
                    
                    VStack(spacing: 2) {
                        HStack {
                            Text(UserSessionManager().getFullName() ?? "")
                                .font(.headline)
                                .foregroundColor(Color.Dark.tone70)
                            Spacer()
                        }
                        HStack {
                            Text(UserSessionManager().getUserName() ?? "")
                                .font(.subheadline)
                                .foregroundColor(Color.Dark.tone70)
                            Spacer()
                        }
                        .padding(.bottom, 4)
                        HStack {
                            Text(verbatim: UserSessionManager().getEmail() ?? "")
                                .font(.subheadline)
                                .foregroundColor(Color.Dark.tone80)
                            
                            Spacer()
                        }
                        HStack {
                            Text(getExpirationAccessToken())
                                .font(.subheadline)
                                .foregroundColor(Color.Dark.tone80)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                }
            }
        }
        .padding()
        .background(Color.Neutral.tone90)
        .onReceive(NotificationCenter.default.publisher(for: .UserSessionDidChanged)) { value in
            shouldUpdateView = false
            shouldUpdateView = true
        }
    }
    
    func getExpirationAccessToken() -> String {
        let token = UserSessionManager().getAccessTokenExpirationDate().toString(format: "dd/MM/yy HH:mm:ss")
        return "exp token: \(token)"
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader()
    }
}
