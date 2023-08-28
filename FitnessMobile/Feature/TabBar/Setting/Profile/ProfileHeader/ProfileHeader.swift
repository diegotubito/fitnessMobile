//
//  ProfileHeader.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 08/08/2023.
//

import SwiftUI

struct ProfileHeader: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var photoPickerManager = PhotoPickerManager()
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 4) {
                photoPickerManager.getImageView()
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay {
                        if photoPickerManager.isLoading {
                            ProgressView()
                                .frame(width: 100, height: 100)
                                .overlay {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                }
                                .shadow(radius: 5)
                        } else {
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        }
                    }
                    .shadow(radius: 10)
                    .onTapGesture {
                        coordinator.presentModal(.photoPicker)
                    }
                Text("_EDIT_BUTTON")
                    .font(.subheadline)
                    .foregroundColor(Color.Yellow.light100)
            }
            
            
            VStack(spacing: 2) {
                HStack {
                    Text(UserSession.getFullName() ?? "")
                        .font(.headline)
                        .foregroundColor(Color.Dark.tone70)
                    Spacer()
                }
                HStack {
                    Text(UserSession.getUserName() ?? "")
                        .font(.subheadline)
                        .foregroundColor(Color.Dark.tone70)
                    Spacer()
                }
                .padding(.bottom, 4)
                HStack {
                    Text(verbatim: UserSession.getEmail() ?? "")
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
                
                HStack {
                    Text(getExpirationRefreshToken())
                        .font(.subheadline)
                        .foregroundColor(Color.Dark.tone80)
                    
                    Spacer()
                }
            }
            
        }
        .padding()
        .background(Color.Neutral.tone90.opacity(0.5))
        .onReceive(NotificationCenter.default.publisher(for: .UserSessionDidChanged)) { value in
            photoPickerManager.fetchProfileImage()
        }
        .onAppear {
            photoPickerManager.fetchProfileImage()
        }
    }
    
    func getExpirationAccessToken() -> String {
        let token = UserSession.getAccessTokenExpirationDate().toString(format: "dd/MM/yy HH:mm:ss")
        return "ATE: \(token)"
    }
    
    func getExpirationRefreshToken() -> String {
        let token = UserSession.getRefreshTokenExpirationDate().toString(format: "dd/MM/yy HH:mm:ss")
        return "RTE: \(token)"
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader()
    }
}
